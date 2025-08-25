;; Healthcare Data Sharing Smart Contract
;; Patients can mint NFTs for medical records and grant/revoke access to healthcare providers

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-token-not-found (err u102))
(define-constant err-already-granted (err u103))
(define-constant err-access-not-granted (err u104))

(define-data-var next-token-id uint u1)

(define-map medical-records
    uint
    {
        patient: principal,
        record-hash: (string-ascii 64),
        record-type: (string-ascii 50),
        created-at: uint
    }
)

(define-map access-permissions
    {token-id: uint, provider: principal}
    bool
)

(define-map token-owners
    uint
    principal
)

(define-private (is-token-owner (token-id uint) (user principal))
    (is-eq (some user) (map-get? token-owners token-id))
)

(define-public (mint-medical-record (record-hash (string-ascii 64)) (record-type (string-ascii 50)))
    (let
        (
            (token-id (var-get next-token-id))
        )
        (map-set medical-records
            token-id
            {
                patient: tx-sender,
                record-hash: record-hash,
                record-type: record-type,
                created-at: block-height
            }
        )
        (map-set token-owners token-id tx-sender)
        (var-set next-token-id (+ token-id u1))
        (ok token-id)
    )
)

(define-public (grant-access (token-id uint) (provider principal))
    (if (is-token-owner token-id tx-sender)
        (begin
            (asserts! (is-none (map-get? access-permissions {token-id: token-id, provider: provider})) err-already-granted)
            (map-set access-permissions {token-id: token-id, provider: provider} true)
            (ok true)
        )
        err-not-token-owner
    )
)

(define-public (revoke-access (token-id uint) (provider principal))
    (if (is-token-owner token-id tx-sender)
        (begin
            (asserts! (is-some (map-get? access-permissions {token-id: token-id, provider: provider})) err-access-not-granted)
            (map-delete access-permissions {token-id: token-id, provider: provider})
            (ok true)
        )
        err-not-token-owner
    )
)

(define-read-only (get-medical-record (token-id uint))
    (map-get? medical-records token-id)
)

(define-read-only (get-token-owner (token-id uint))
    (map-get? token-owners token-id)
)

(define-read-only (has-access (token-id uint) (provider principal))
    (default-to false (map-get? access-permissions {token-id: token-id, provider: provider}))
)

(define-read-only (get-next-token-id)
    (var-get next-token-id)
)