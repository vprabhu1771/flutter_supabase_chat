### **2. Insert Conversations**
(One private chat and one group chat)

```sql
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    is_group BOOLEAN NOT NULL,
    name VARCHAR(255) NULL
);
```

```sql
INSERT INTO conversations (id, is_group, name) VALUES
('660e8400-e29b-41d4-a716-446655440000', false, NULL), -- Private Chat
('660e8400-e29b-41d4-a716-446655440001', true, 'Project Team Chat'); -- Group Chat
```
