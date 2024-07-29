-- name: CreateTransfer :one
INSERT INTO transfers(
    from_account_id, to_account_id, amount
) VALUES(
    $1, $2, $3
) RETURNING *;

-- name: GetTransfer :one
Select * From transfers
Where id = $1 Limit 1;

-- name: ListTransfers :many
Select * From transfers
WHERE from_account_id = $1 or to_account_id = $2
ORDER BY id 
LIMIT $3
OFFSET $4;