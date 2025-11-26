/* eslint-disable require-jsdoc */
import {
  Timestamp,
  DocumentData,
  DocumentSnapshot,
} from "firebase-admin/firestore";
import {
  Change,
  FirestoreAuthEvent,
} from "firebase-functions/v2/firestore";
import {afterEach, beforeEach, describe, expect, it, vi} from "vitest";
import {
  extractChangedFields,
  determineOperation,
  handleDocumentChange,
} from "../changeLog.service";
import * as changeLogRepository from "../changeLog.repository";

vi.mock("../changeLog.repository", () => ({
  createEntry: vi.fn().mockResolvedValue(undefined),
}));

type DocumentEvent = FirestoreAuthEvent<
  Change<DocumentSnapshot> | undefined,
  {documentPath: string}
>;

const repoMock = vi.mocked(changeLogRepository);

describe("changeLog.service", () => {
  const fakeTimestamp = Timestamp.fromMillis(1_700_000_000_000);

  beforeEach(() => {
    vi.spyOn(Timestamp, "now").mockReturnValue(fakeTimestamp);
  });

  afterEach(() => {
    vi.restoreAllMocks();
    vi.clearAllMocks();
  });

  it(
    "persists a change log entry for document updates with data diffs",
    async () => {
      const event = buildEvent({
        path: "desks/desk-123",
        beforeData: {name: "Desk A", seats: 4},
        afterData: {name: "Desk B", seats: 4},
      });

      await handleDocumentChange(event);

      expect(repoMock.createEntry).toHaveBeenCalledTimes(1);
      expect(repoMock.createEntry).toHaveBeenCalledWith({
        documentPath: "desks/desk-123",
        collection: "desks",
        eventId: "event-123",
        operation: "updated",
        changedFields: ["name"],
        beforeData: {name: "Desk A", seats: 4},
        afterData: {name: "Desk B", seats: 4},
        authType: "system",
        authId: "user-123",
        loggedAt: fakeTimestamp,
      });
    },
  );

  it("skips logging when update results in no field changes", async () => {
    const event = buildEvent({
      path: "desks/desk-123",
      beforeData: {name: "Desk A"},
      afterData: {name: "Desk A"},
    });

    await handleDocumentChange(event);

    expect(repoMock.createEntry).not.toHaveBeenCalled();
  });

  it(
    "ignores writes to the changeLogs collection to avoid recursion",
    async () => {
      const event = buildEvent({
        path: "changeLogs/log-1",
        beforeData: null,
        afterData: {documentPath: "desks/desk-123"},
      });

      await handleDocumentChange(event);

      expect(repoMock.createEntry).not.toHaveBeenCalled();
    },
  );
});

describe("determineOperation", () => {
  it("identifies create, update, delete correctly", () => {
    expect(determineOperation(false, true)).toBe("created");
    expect(determineOperation(true, false)).toBe("deleted");
    expect(determineOperation(true, true)).toBe("updated");
    expect(determineOperation(false, false)).toBeNull();
  });
});

describe("extractChangedFields", () => {
  it("returns sorted keys for created documents", () => {
    expect(extractChangedFields(null, {b: 1, a: 2})).toEqual(["a", "b"]);
  });

  it("returns keys for deleted documents", () => {
    expect(extractChangedFields({x: 1}, null)).toEqual(["x"]);
  });

  it("performs deep equality checks for nested objects", () => {
    const beforeData = {profile: {name: "Jane", skills: ["a", "b"]}};
    const afterData = {profile: {name: "Jane", skills: ["a", "c"]}};

    expect(extractChangedFields(beforeData, afterData)).toEqual(["profile"]);
  });
});

function buildEvent(args: {
  path: string;
  beforeData: DocumentData | null;
  afterData: DocumentData | null;
  authType?: "system";
  authId?: string | null;
}): DocumentEvent {
  const beforeSnapshot = buildSnapshot(args.beforeData, args.path);
  const afterSnapshot = buildSnapshot(args.afterData, args.path);

  return {
    data: {
      before: beforeSnapshot,
      after: afterSnapshot,
    },
    params: {
      documentPath: args.path,
    },
    id: "event-123",
    time: "2024-01-01T00:00:00.000Z",
    type: "google.cloud.firestore.document.v1.written",
    source:
      "//firestore.googleapis.com/projects/demo/databases/(default)/documents",
    specversion: "1.0",
    subject: args.path,
    location: "us-central1",
    project: "demo",
    database: "(default)",
    namespace: "(default)",
    document: args.path,
    authType: args.authType ?? "system",
    authId: args.authId ?? "user-123",
  };
}

function buildSnapshot(
  data: DocumentData | null,
  path: string,
): DocumentSnapshot {
  return {
    exists: data !== null,
    data: () => data ?? undefined,
    ref: {path},
  } as unknown as DocumentSnapshot;
}
