import {
  onDocumentWrittenWithAuthContext,
} from "firebase-functions/v2/firestore";
import {handleDocumentChange} from "./changeLog.service.js";

export const logDocumentChanges = onDocumentWrittenWithAuthContext(
  {
    document: "{documentPath=**}",
  },
  handleDocumentChange,
);
