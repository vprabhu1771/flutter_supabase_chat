truncate table messages restart identity;

INSERT INTO messages (receiver_id, sender_id, message) VALUES
('6759bb91-7dcf-4128-b154-0a36d47339cb', '217d83ab-67a5-494e-9fab-b7890b1e988d', 'Hello! How are you?'),
('217d83ab-67a5-494e-9fab-b7890b1e988d', '6759bb91-7dcf-4128-b154-0a36d47339cb', 'I m good, thanks! How about you?'),
('6759bb91-7dcf-4128-b154-0a36d47339cb', '217d83ab-67a5-494e-9fab-b7890b1e988d', 'Doing great! Working on a new project.'),
('217d83ab-67a5-494e-9fab-b7890b1e988d', '6759bb91-7dcf-4128-b154-0a36d47339cb', 'That sounds interesting! Tell me more.');
