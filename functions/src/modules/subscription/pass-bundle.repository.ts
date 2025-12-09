import {Timestamp, QueryDocumentSnapshot} from "firebase-admin/firestore";
import {db} from "../../config/firebaseAdmin.js";
import {
  PASS_BUNDLES_COLLECTION,
  PassBundle,
  PassBundleCreateDto,
  PassBundleUpdateDto,
  Access,
} from "./subscription.types.js";

const passBundlesCol = () => db().collection(PASS_BUNDLES_COLLECTION);

/**
 * Finds a pass bundle by ID.
 */
export async function findPassBundleById(
  id: string,
): Promise<PassBundle | null> {
  const doc = await passBundlesCol().doc(id).get();
  if (!doc.exists) return null;
  return {id: doc.id, ...(doc.data() as Omit<PassBundle, "id">)};
}

/**
 * Finds all pass bundles for a user.
 */
export async function findPassBundlesByUserId(
  userId: string,
): Promise<PassBundle[]> {
  const snap = await passBundlesCol()
    .where("userId", "==", userId)
    .orderBy("createdAt", "desc")
    .get();
  return snap.docs.map((doc: QueryDocumentSnapshot) => ({
    id: doc.id,
    ...(doc.data() as Omit<PassBundle, "id">),
  }));
}

/**
 * Finds active pass bundles for a user.
 */
export async function findActivePassBundlesByUserId(
  userId: string,
): Promise<PassBundle[]> {
  const snap = await passBundlesCol()
    .where("userId", "==", userId)
    .where("status", "==", "active")
    .orderBy("createdAt", "desc")
    .get();
  return snap.docs.map((doc: QueryDocumentSnapshot) => ({
    id: doc.id,
    ...(doc.data() as Omit<PassBundle, "id">),
  }));
}

/**
 * Creates a new pass bundle.
 */
export async function createPassBundle(
  dto: PassBundleCreateDto,
  planQuota: {dayPassCredits: number; access: Access},
): Promise<PassBundle> {
  const now = Timestamp.now();
  const bundle: Omit<PassBundle, "id"> = {
    userId: dto.userId,
    planId: dto.planId,
    status: "active",
    totalCredits: planQuota.dayPassCredits,
    remainingCredits: planQuota.dayPassCredits,
    validFrom: dto.validFrom,
    validUntil: dto.validUntil,
    access: planQuota.access,
    createdAt: now,
    updatedAt: now,
  };

  const docRef = await passBundlesCol().add(bundle);
  return {id: docRef.id, ...bundle};
}

/**
 * Updates a pass bundle.
 */
export async function updatePassBundle(
  id: string,
  dto: PassBundleUpdateDto,
): Promise<PassBundle> {
  const ref = passBundlesCol().doc(id);
  const updateData: Partial<PassBundle> = {
    ...dto,
    updatedAt: Timestamp.now(),
  };
  await ref.update(updateData);
  const updated = await ref.get();
  if (!updated.exists) {
    throw new Error("Pass bundle not found after update");
  }
  return {id: updated.id, ...(updated.data() as Omit<PassBundle, "id">)};
}

/**
 * Deletes a pass bundle.
 */
export async function deletePassBundle(id: string): Promise<void> {
  await passBundlesCol().doc(id).delete();
}

