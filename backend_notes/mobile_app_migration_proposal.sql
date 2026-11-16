-- REVIEWED PROPOSAL ONLY. Do not run on production until a backup is taken
-- and the PHP authentication/order flows have been verified.

ALTER TABLE orders
  ADD COLUMN customer_id BIGINT UNSIGNED NULL AFTER marketer_id,
  ADD INDEX idx_orders_customer_created (customer_id, created_at),
  ADD CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE SET NULL;

CREATE TABLE mobile_access_tokens (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  token_hash CHAR(64) NOT NULL UNIQUE,
  expires_at DATETIME NOT NULL,
  revoked_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_used_at DATETIME NULL,
  device_name VARCHAR(120) NULL,
  INDEX idx_mobile_tokens_user_expiry (user_id, expires_at),
  CONSTRAINT fk_mobile_tokens_user
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
