# Vindora Customer App — Phase 1

## Confirmed findings from the supplied PHP archive

- The existing backend is PHP + PDO + MySQL (`backend/bootstrap.php`).
- Existing API entry point: `backend/api.php`.
- Existing public endpoints include `products`, `store_banners`, `store_settings`, and `shipping_rates`.
- Existing storefront checkout action is `create_store_order`; it currently accepts guest checkout and inserts into `orders` without a customer user ID.
- `orders` currently has customer name/phone/address fields but no `customer_id` relation.
- Existing API authentication is based on `$_SESSION['user']` (`current_user()` in `backend/bootstrap.php`). The API rejects requests without a PHP session before protected actions.
- Existing `orders` API action is limited to admin/marketer and is not a customer order-history endpoint.
- `users` includes `customer` role and `password_hash`; the schema includes active/pending/suspended status. The archive does not include the actual `/auth/` login/registration implementation referenced by root wrapper files, so its account verification flow must be inspected on the deployed server before changing it.

## Mobile app decisions

- Customer-only app; no marketer, supplier, or admin dashboards.
- Customer must authenticate before checkout.
- Every app-created order must be attached to the authenticated customer account.
- Customers can only read their own order history and order details/tracking.
- Flutter stores the access token in platform secure storage, never in plain preferences.

## Proposed API contract (not yet deployed)

Base path: `/backend/mobile_api.php`

- `POST ?action=login` — email + password; only active customer accounts; returns a short-lived bearer access token and customer profile.
- `POST ?action=register` — to be implemented only after the existing email-verification and activation workflow is confirmed.
- `POST ?action=logout` — revoke the current token.
- `GET ?action=me` — current customer profile.
- `GET ?action=products` — customer catalog; may reuse the existing public catalog query.
- `GET ?action=shipping_rates` — active shipping rates.
- `POST ?action=create_order` — requires bearer token; derives customer name/phone from the account or validated account fields; inserts `customer_id` on the order; no guest path.
- `GET ?action=my_orders` — orders filtered by `customer_id` from the token, never a client-supplied user ID.
- `GET ?action=order_detail&order_id=...` — verifies ownership before returning order and items.

## Security requirements

- Generate cryptographically random bearer tokens; store only SHA-256 hashes in MySQL.
- Enforce token expiry and revocation server-side.
- Compare passwords using `password_verify()`.
- Require `role='customer'` and `status='active'` for customer app login.
- Never accept a customer/user ID from the client as the identity source.
- Use prepared statements and ownership checks on every order read.
- Keep DB credentials and signing secrets on the PHP server only.
- Use HTTPS only in production.

## Deployment caution

Do not apply the SQL migration or replace the existing checkout action until the deployed authentication/verification flow and order status lifecycle have been checked. The migration below is additive and is supplied as a reviewed proposal, not as an executed change.
