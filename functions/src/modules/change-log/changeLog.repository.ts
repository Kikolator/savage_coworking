import {db} from "../../config/firebaseAdmin";
import {CHANGE_LOG_COLLECTION, ChangeLogEntry} from "./changeLog.types";

/**
 * Persists a new entry in the changeLogs collection.
 *
 * @param {ChangeLogEntry} entry - Data describing the mutation.
 * @return {Promise<void>} Resolves when the write completes.
 */
export async function createEntry(entry: ChangeLogEntry): Promise<void> {
  await db().collection(CHANGE_LOG_COLLECTION).add(entry);
}
