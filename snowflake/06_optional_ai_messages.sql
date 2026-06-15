-- 06_optional_ai_messages.sql
-- Optional table to store AI-generated message templates or examples

CREATE OR REPLACE TABLE gold.ai_message_templates (
  template_id STRING,
  intent STRING,
  template_text STRING,
  created_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Insert example templates
-- INSERT INTO gold.ai_message_templates (template_id, intent, template_text) VALUES ('tpl_1', 'refill_reminder', 'Hi {{first_name}}, it's time to refill your prescription.');
