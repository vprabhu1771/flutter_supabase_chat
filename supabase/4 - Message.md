### **4. Insert Messages**
(John sends a message to Jane, and Jane replies)

```sql
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    sender_id UUID NOT NULL,
    content TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE
);
```

```sql
```sql
ALTER TABLE messages 
ALTER COLUMN id SET DEFAULT gen_random_uuid();
```
```

```sql
INSERT INTO messages (id, conversation_id, sender_id, content) VALUES
('880e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000', 'Hey Jane, how are you?'),
('880e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440001', 'I am good, John! How about you?'),

('880e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 'Hello team! Let’s start our meeting.'),
('880e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'Yes, I am ready.');
```