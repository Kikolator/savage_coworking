import {
  DocumentData,
  DocumentSnapshot,
  Timestamp,
} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import {
  AuthType,
  Change,
  FirestoreAuthEvent,
} from "firebase-functions/v2/firestore";
import * as changeLogRepository from "./changeLog.repository";
import {
  CHANGE_LOG_COLLECTION,
  ChangeLogEntry,
  ChangeLogOperation,
} from "./changeLog.types";

type AnyDocumentEvent = FirestoreAuthEvent<
  Change<DocumentSnapshot> | undefined,
  {documentPath: string}
>;

const COLLECTIONS_TO_SKIP = new Set([CHANGE_LOG_COLLECTION]);

/**
 * Logs every Firestore write into the change log.
 *
 * @param {AnyDocumentEvent} event - Firestore change event payload.
 * @return {Promise<void>} Resolves when the log entry is stored.
 */
export async function handleDocumentChange(
  event: AnyDocumentEvent,
): Promise<void> {
  const change = event.data;
  if (!change) {
    logger.warn("Firestore change event missing payload", {
      eventId: event.id,
    });
    return;
  }

  const documentPath = event.document;
  const collection = getTopLevelCollection(documentPath);

  if (!collection || shouldSkipCollection(collection)) {
    return;
  }

  const beforeData = getSnapshotData(change.before);
  const afterData = getSnapshotData(change.after);

  const entry = buildChangeLogEntry({
    beforeExists: change.before.exists,
    afterExists: change.after.exists,
    beforeData,
    afterData,
    documentPath,
    collection,
    eventId: event.id,
    authType: event.authType ?? "unknown",
    authId: event.authId ?? null,
  });

  if (!entry) {
    return;
  }

  try {
    await changeLogRepository.createEntry(entry);
  } catch (error) {
    logger.error("Failed to persist change log entry", {
      eventId: event.id,
      documentPath,
      error,
    });
    throw error;
  }
}

/**
 * Builds a change-log entry from the given Firestore change and metadata.
 *
 * @param {object} args - Combined snapshot metadata and context.
 * @param {boolean} args.beforeExists - Indicates whether the old doc existed.
 * @param {boolean} args.afterExists - Indicates whether the new doc exists.
 * @param {DocumentData|null} args.beforeData - Previous document data.
 * @param {DocumentData|null} args.afterData - Latest document data.
 * @param {string} args.documentPath - Full Firestore document path.
 * @param {string} args.collection - Top-level collection name.
 * @param {string} args.eventId - Cloud Event identifier.
 * @param {AuthType|"unknown"} args.authType - Auth principal type.
 * @param {string|null} args.authId - Identifier for the principal.
 * @return {ChangeLogEntry|null} Entry to persist or null if skipped.
 */
export function buildChangeLogEntry(args: {
  beforeExists: boolean;
  afterExists: boolean;
  beforeData: DocumentData | null;
  afterData: DocumentData | null;
  documentPath: string;
  collection: string;
  eventId: string;
  authType: AuthType | "unknown";
  authId: string | null;
}): ChangeLogEntry | null {
  const operation = determineOperation(args.beforeExists, args.afterExists);

  if (!operation) {
    return null;
  }

  const changedFields = extractChangedFields(args.beforeData, args.afterData);

  if (operation === "updated" && changedFields.length === 0) {
    return null;
  }

  return {
    documentPath: args.documentPath,
    collection: args.collection,
    eventId: args.eventId,
    operation,
    changedFields,
    beforeData: args.beforeData,
    afterData: args.afterData,
    authType: args.authType,
    authId: args.authId,
    loggedAt: Timestamp.now(),
  };
}

/**
 * Determines the CRUD operation that occurred between two snapshots.
 *
 * @param {boolean} beforeExists - Whether the previous snapshot existed.
 * @param {boolean} afterExists - Whether the new snapshot exists.
 * @return {ChangeLogOperation|null} Operation or null when no change.
 */
export function determineOperation(
  beforeExists: boolean,
  afterExists: boolean,
): ChangeLogOperation | null {
  if (!beforeExists && afterExists) {
    return "created";
  }

  if (beforeExists && !afterExists) {
    return "deleted";
  }

  if (beforeExists && afterExists) {
    return "updated";
  }

  return null;
}

/**
 * Returns the sorted list of top-level fields that changed between snapshots.
 *
 * @param {DocumentData|null} beforeData - Previous document data, if any.
 * @param {DocumentData|null} afterData - Latest document data, if any.
 * @return {string[]} Sorted list of changed field names.
 */
export function extractChangedFields(
  beforeData: DocumentData | null,
  afterData: DocumentData | null,
): string[] {
  if (!beforeData && afterData) {
    return Object.keys(afterData).sort();
  }

  if (beforeData && !afterData) {
    return Object.keys(beforeData).sort();
  }

  if (!beforeData || !afterData) {
    return [];
  }

  const keys = new Set([
    ...Object.keys(beforeData),
    ...Object.keys(afterData),
  ]);

  const changedFields: string[] = [];
  for (const key of keys) {
    if (!deepEqual(beforeData[key], afterData[key])) {
      changedFields.push(key);
    }
  }

  return changedFields.sort();
}

/**
 * Performs a deep equality check that understands Firestore timestamps.
 *
 * @param {unknown} valueA - First value to compare.
 * @param {unknown} valueB - Second value to compare.
 * @return {boolean} True when both values are equal.
 */
function deepEqual(valueA: unknown, valueB: unknown): boolean {
  if (valueA === valueB) {
    return true;
  }

  if (valueA instanceof Timestamp && valueB instanceof Timestamp) {
    return valueA.isEqual(valueB);
  }

  if (valueA === null || valueB === null) {
    return valueA === valueB;
  }

  if (Array.isArray(valueA) && Array.isArray(valueB)) {
    if (valueA.length !== valueB.length) {
      return false;
    }

    return valueA.every((item, index) => deepEqual(item, valueB[index]));
  }

  if (Array.isArray(valueA) || Array.isArray(valueB)) {
    return false;
  }

  if (isPlainObject(valueA) && isPlainObject(valueB)) {
    const keysA = Object.keys(valueA);
    const keysB = Object.keys(valueB);

    if (keysA.length !== keysB.length) {
      return false;
    }

    return keysA.every((key) =>
      deepEqual(
        (valueA as Record<string, unknown>)[key],
        (valueB as Record<string, unknown>)[key],
      ),
    );
  }

  return false;
}

/**
 * Returns true when the value is a plain JavaScript object.
 *
 * @param {unknown} value - Value to validate.
 * @return {boolean} True for plain objects.
 */
function isPlainObject(value: unknown): value is Record<string, unknown> {
  return (
    typeof value === "object" &&
    value !== null &&
    Object.getPrototypeOf(value) === Object.prototype
  );
}

/**
 * Extracts the top-level collection segment from a document path.
 *
 * @param {string} path - Firestore document path.
 * @return {string|null} Top-level collection or null when missing.
 */
function getTopLevelCollection(path: string): string | null {
  if (!path) {
    return null;
  }

  return path.split("/")[0] ?? null;
}

/**
 * Determines whether the given collection should be ignored by the logger.
 *
 * @param {string} collection - Collection name to evaluate.
 * @return {boolean} True when logging should be skipped.
 */
function shouldSkipCollection(collection: string): boolean {
  return COLLECTIONS_TO_SKIP.has(collection);
}

/**
 * Returns the raw data for a snapshot or null when the document does not exist.
 *
 * @param {DocumentSnapshot} snapshot - Firestore snapshot to unwrap.
 * @return {DocumentData|null} Snapshot data or null when absent.
 */
function getSnapshotData(snapshot: DocumentSnapshot): DocumentData | null {
  if (!snapshot.exists) {
    return null;
  }

  const data = snapshot.data();
  return data ?? null;
}
