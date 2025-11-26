import {DocumentData, Timestamp} from "firebase-admin/firestore";
import {AuthType} from "firebase-functions/v2/firestore";

export type ChangeLogOperation = "created" | "updated" | "deleted";

export interface ChangeLogEntry {
  documentPath: string;
  collection: string;
  eventId: string;
  operation: ChangeLogOperation;
  changedFields: string[];
  beforeData: DocumentData | null;
  afterData: DocumentData | null;
  authType: AuthType | "unknown";
  authId: string | null;
  loggedAt: Timestamp;
}

export const CHANGE_LOG_COLLECTION = "changeLogs";
