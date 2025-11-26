import {App, getApps, initializeApp} from "firebase-admin/app";
import {Firestore, getFirestore} from "firebase-admin/firestore";

let cachedApp: App | undefined;

/**
 * Ensures the Firebase Admin app is initialized exactly once per instance.
 *
 * @return {App} Initialized Firebase Admin application.
 */
function getOrInitApp(): App {
  if (!cachedApp) {
    const apps = getApps();
    cachedApp = apps.length > 0 ? apps[0] : initializeApp();
  }

  return cachedApp;
}

/**
 * Returns the shared Firestore instance for the initialized Admin app.
 *
 * @return {Firestore} Firestore connection for the singleton app.
 */
export function db(): Firestore {
  return getFirestore(getOrInitApp());
}
