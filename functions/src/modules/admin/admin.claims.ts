import {onCall, HttpsError} from "firebase-functions/v2/https";
import {auth} from "../../config/firebaseAdmin.js";

/**
 * Checks if any users in the system have admin custom claims.
 * Uses listUsers with a limit to efficiently check for admins.
 *
 * @return {Promise<boolean>} True if any admin users exist, false otherwise.
 */
async function hasAnyAdmins(): Promise<boolean> {
  try {
    // List users with a reasonable limit to check for admins
    // In most cases, checking first 1000 users should be sufficient
    const listUsersResult = await auth().listUsers(1000);

    for (const userRecord of listUsersResult.users) {
      const customClaims = userRecord.customClaims || {};
      if (customClaims.admin === true) {
        return true;
      }
    }

    return false;
  } catch (error) {
    // If listing fails, assume admins exist for security
    console.error("Error checking for admins:", error);
    return true;
  }
}

/**
 * Callable function for setting admin custom claims on a user.
 *
 * Security:
 * - Requires authentication
 * - Allows bootstrap: if no admins exist, any authenticated user can
 *   set first admin
 * - After bootstrap: only existing admins can set admin claims
 *
 * @param request - Function request with uid and isAdmin in data
 * @return {Promise<{success: boolean, uid: string, isAdmin: boolean}>}
 */
export const setAdminClaim = onCall(
  {
    region: "us-central1",
  },
  async (request) => {
    // Require authentication
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "The function must be called while authenticated.",
      );
    }

    const {uid, isAdmin} = request.data as {
      uid?: string;
      isAdmin?: boolean;
    };

    // Validate input
    if (!uid || typeof uid !== "string") {
      throw new HttpsError(
        "invalid-argument",
        "uid (string) is required",
      );
    }

    if (typeof isAdmin !== "boolean") {
      throw new HttpsError(
        "invalid-argument",
        "isAdmin (boolean) is required",
      );
    }

    // Check if target user exists
    try {
      await auth().getUser(uid);
    } catch {
      throw new HttpsError(
        "not-found",
        `User with uid ${uid} does not exist`,
      );
    }

    // Check if caller is admin
    const callerIsAdmin = request.auth.token.admin === true;

    // If caller is not admin, check if we're in bootstrap mode
    if (!callerIsAdmin) {
      const adminsExist = await hasAnyAdmins();

      if (adminsExist) {
        // Admins exist, but caller is not admin - deny
        throw new HttpsError(
          "permission-denied",
          "Only admins can set admin claims when admins already exist.",
        );
      }
      // No admins exist - allow bootstrap
      // (any authenticated user can set first admin)
    }

    // Set the custom claim
    try {
      await auth().setCustomUserClaims(uid, {admin: isAdmin});

      return {
        success: true,
        uid,
        isAdmin,
      };
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      console.error("Error setting custom claim:", error);
      throw new HttpsError(
        "internal",
        `Failed to set custom claim: ${errorMessage}`,
      );
    }
  },
);

