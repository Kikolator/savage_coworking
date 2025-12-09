import {Timestamp, QueryDocumentSnapshot} from "firebase-admin/firestore";
import {db} from "../../config/firebaseAdmin.js";
import {
  USAGE_COLLECTION,
  Usage,
  UsageCreateDto,
  UsageUpdateDto,
} from "./subscription.types.js";

const usageCol = () => db().collection(USAGE_COLLECTION);

/**
 * Finds a usage record by ID.
 */
export async function findUsageById(id: string): Promise<Usage | null> {
  const doc = await usageCol().doc(id).get();
  if (!doc.exists) return null;
  return {id: doc.id, ...(doc.data() as Omit<Usage, "id">)};
}

/**
 * Finds usage records for a user.
 */
export async function findUsageByUserId(
  userId: string,
): Promise<Usage[]> {
  const snap = await usageCol()
    .where("userId", "==", userId)
    .orderBy("periodStart", "desc")
    .get();
  return snap.docs.map((doc: QueryDocumentSnapshot) => ({
    id: doc.id,
    ...(doc.data() as Omit<Usage, "id">),
  }));
}

/**
 * Finds usage records for a subscription in a period.
 */
export async function findUsageBySubscriptionAndPeriod(
  subscriptionId: string,
  periodStart: Timestamp,
  periodEnd: Timestamp,
): Promise<Usage | null> {
  const snap = await usageCol()
    .where("subscriptionId", "==", subscriptionId)
    .where("periodStart", "==", periodStart)
    .where("periodEnd", "==", periodEnd)
    .limit(1)
    .get();
  if (snap.empty) return null;
  const doc = snap.docs[0];
  return {id: doc.id, ...(doc.data() as Omit<Usage, "id">)};
}

/**
 * Finds usage records for a pass bundle in a period.
 */
export async function findUsageByPassBundleAndPeriod(
  passBundleId: string,
  periodStart: Timestamp,
  periodEnd: Timestamp,
): Promise<Usage | null> {
  const snap = await usageCol()
    .where("passBundleId", "==", passBundleId)
    .where("periodStart", "==", periodStart)
    .where("periodEnd", "==", periodEnd)
    .limit(1)
    .get();
  if (snap.empty) return null;
  const doc = snap.docs[0];
  return {id: doc.id, ...(doc.data() as Omit<Usage, "id">)};
}

/**
 * Creates a new usage record.
 */
export async function createUsage(dto: UsageCreateDto): Promise<Usage> {
  const now = Timestamp.now();
  const usage: Omit<Usage, "id"> = {
    userId: dto.userId,
    subscriptionId: dto.subscriptionId,
    passBundleId: dto.passBundleId,
    periodStart: dto.periodStart,
    periodEnd: dto.periodEnd,
    deskMinutesUsed: 0,
    meetingMinutesUsed: 0,
    createdAt: now,
    updatedAt: now,
  };

  const docRef = await usageCol().add(usage);
  return {id: docRef.id, ...usage};
}

/**
 * Updates a usage record.
 */
export async function updateUsage(
  id: string,
  dto: UsageUpdateDto,
): Promise<Usage> {
  const ref = usageCol().doc(id);
  const updateData: Partial<Usage> = {
    ...dto,
    updatedAt: Timestamp.now(),
  };
  await ref.update(updateData);
  const updated = await ref.get();
  if (!updated.exists) {
    throw new Error("Usage record not found after update");
  }
  return {id: updated.id, ...(updated.data() as Omit<Usage, "id">)};
}

/**
 * Deletes a usage record.
 */
export async function deleteUsage(id: string): Promise<void> {
  await usageCol().doc(id).delete();
}

