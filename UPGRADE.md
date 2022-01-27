# Upgrading Killswitch Backend

## release/1.1.0

### Organization cache counters

We now track `memberships_count` and `applications_count` for organizations. We
need to calculate initial value.

```ruby
Organization.find_each do |organization|
  Organization.reset_counters(organization.id, :memberships)
  Organization.reset_counters(organization.id, :applications)
end
```

## release/1.0.0

### New membership types

We don’t need the `member` type because we don’t have role-specific abilities.
Let’s convert everything to admins.

```ruby
Membership.where(membership_type: 'member').update_all(membership_type: 'admin')
```
