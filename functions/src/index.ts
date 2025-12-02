import {setGlobalOptions} from "firebase-functions/v2";
import {logDocumentChanges} from "./modules/change-log/changeLog.trigger";

setGlobalOptions({
  maxInstances: 10,
  region: "us-central1",
});

export {logDocumentChanges};
