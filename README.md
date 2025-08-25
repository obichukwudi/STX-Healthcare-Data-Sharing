Healthcare Data Sharing Smart Contract

Overview

This smart contract provides a decentralized way for patients to mint NFTs representing their medical records and to manage access permissions for healthcare providers. It ensures that patients retain full control of their medical data while enabling secure and auditable sharing within the Stacks blockchain ecosystem.

✨ Features

Medical Record NFTs

Patients can mint NFTs where each token represents a medical record.

Each record stores a record-hash, record-type, and timestamp (created-at).

Ownership

Each NFT is tied to the patient who created it.

Ownership is enforced when granting or revoking access.

Access Management

Patients can grant access to healthcare providers for specific records.

Patients can revoke access at any time.

The system ensures permissions cannot be granted twice or revoked if not granted.

Data Privacy

Only hashed identifiers of records (record-hash) are stored on-chain.

Full medical data remains off-chain, ensuring privacy while providing proof of authenticity.

🔑 Key Functions
Public Functions

(mint-medical-record (record-hash (string-ascii 64)) (record-type (string-ascii 50)))
Creates a new medical record NFT and assigns ownership to the patient (caller).

(grant-access (token-id uint) (provider principal))
Grants access rights to a healthcare provider for a specific record.

(revoke-access (token-id uint) (provider principal))
Revokes access rights previously granted to a provider.

Read-Only Functions

(get-medical-record (token-id uint)) → Returns details of a medical record.

(get-token-owner (token-id uint)) → Returns the owner (patient) of a medical record.

(has-access (token-id uint) (provider principal)) → Returns whether a provider has access to a specific record.

(get-next-token-id) → Returns the next token ID available for minting.

🛑 Error Handling

err-owner-only (u100) → Only contract owner restriction (not actively used).

err-not-token-owner (u101) → Caller is not the owner of the record.

err-token-not-found (u102) → Token ID does not exist.

err-already-granted (u103) → Access has already been granted.

err-access-not-granted (u104) → Access does not exist to be revoked.

⚙️ Example Workflow

Patient calls mint-medical-record with their medical record hash and type.

Patient grants a doctor access with grant-access.

Doctor checks has-access before attempting to view record details.

Patient can later revoke access with revoke-access.

🚀 Use Cases

Secure patient-controlled health record management.

Hospitals/clinics accessing only authorized patient data.

Proof-of-existence for immutable medical record history.