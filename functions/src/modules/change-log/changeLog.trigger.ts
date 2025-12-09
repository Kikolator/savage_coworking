import {
  onDocumentWrittenWithAuthContext,
} from "firebase-functions/v2/firestore";
import {handleDocumentChange} from "./changeLog.service.js";

export const logDocumentChanges = onDocumentWrittenWithAuthContext(
  {
    document: "{documentPath=**}",
    region: "europe-west1",
  },
  handleDocumentChange,
);
