import os

import pandas as pd
import streamlit as st
import snowflake.connector
from dotenv import load_dotenv

load_dotenv()

st.set_page_config(
    page_title="MedSync AI",
    page_icon="💊",
    layout="wide"
)

st.title("💊 MedSync AI — Medication Reminder & Refill Intelligence Platform")
st.caption(
    "Snowflake-powered medication adherence, refill prediction, "
    "nearest pharmacy recommendation, and reminder-message dashboard."
)

# -----------------------------
# Snowflake connection
# -----------------------------
@st.cache_resource
def get_connection():
    return snowflake.connector.connect(
        user=os.getenv("SNOWFLAKE_USER"),
        password=os.getenv("SNOWFLAKE_PASSWORD"),
        account=os.getenv("SNOWFLAKE_ACCOUNT"),
        warehouse="MEDSYNC_WH",
        database="MEDSYNC_AI",
        schema="GOLD",
        role="ACCOUNTADMIN",
    )

conn = get_connection()

@st.cache_data(ttl=300)
def run_query(query):
    return pd.read_sql(query, conn)

# -----------------------------
# Sidebar
# -----------------------------
page = st.sidebar.radio(
    "Navigation",
    [
        "Overview",
        "Patient Adherence",
        "Reminder Queue",
        "Refill Recommendations",
        "Refill Messages",
        "High-Risk Patients"
    ]
)

# -----------------------------
# Overview
# -----------------------------
if page == "Overview":
    st.subheader("Platform Overview")

    metrics = run_query("""
        SELECT
            COUNT(DISTINCT patient_id) AS patients,
            COUNT(DISTINCT prescription_id) AS prescriptions,
            ROUND(AVG(adherence_rate), 4) AS avg_adherence_rate,
            COUNT_IF(adherence_risk = 'High Risk') AS high_risk_prescriptions
        FROM MART_PATIENT_ADHERENCE
    """)

    refill_metrics = run_query("""
        SELECT
            COUNT_IF(refill_status = 'Urgent Refill') AS urgent_refills,
            COUNT_IF(refill_status = 'Refill Soon') AS refill_soon,
            COUNT_IF(refill_status = 'Sufficient Stock') AS sufficient_stock
        FROM MART_REFILL_PREDICTION
    """)

    col1, col2, col3, col4 = st.columns(4)

    col1.metric("Patients", int(metrics["PATIENTS"][0]))
    col2.metric("Prescriptions", int(metrics["PRESCRIPTIONS"][0]))
    col3.metric("Avg Adherence %", round(float(metrics["AVG_ADHERENCE_RATE"][0]) * 100, 2))
    col4.metric("High-Risk Prescriptions", int(metrics["HIGH_RISK_PRESCRIPTIONS"][0]))

    col5, col6, col7 = st.columns(3)
    col5.metric("Urgent Refills", int(refill_metrics["URGENT_REFILLS"][0]))
    col6.metric("Refill Soon", int(refill_metrics["REFILL_SOON"][0]))
    col7.metric("Sufficient Stock", int(refill_metrics["SUFFICIENT_STOCK"][0]))

    st.divider()

    st.subheader("Refill Status Distribution")

    refill_df = run_query("""
        SELECT refill_status, COUNT(*) AS count
        FROM MART_REFILL_PREDICTION
        GROUP BY refill_status
        ORDER BY count DESC
    """)

    st.bar_chart(refill_df.set_index("REFILL_STATUS"))

    st.subheader("Adherence Risk Distribution")

    risk_df = run_query("""
        SELECT adherence_risk, COUNT(*) AS count
        FROM MART_PATIENT_ADHERENCE
        GROUP BY adherence_risk
        ORDER BY count DESC
    """)

    st.bar_chart(risk_df.set_index("ADHERENCE_RISK"))

# -----------------------------
# Patient Adherence
# -----------------------------
elif page == "Patient Adherence":
    st.subheader("Patient Medication Adherence")

    df = run_query("""
        SELECT
            patient_id,
            first_name,
            last_name,
            prescription_id,
            medicine_name,
            drug_class,
            total_scheduled_doses,
            doses_taken,
            doses_missed,
            doses_skipped,
            doses_snoozed,
            ROUND(adherence_rate * 100, 2) AS adherence_percentage,
            adherence_risk
        FROM MART_PATIENT_ADHERENCE
        ORDER BY adherence_rate ASC
        LIMIT 200
    """)

    st.dataframe(df, use_container_width=True)

# -----------------------------
# Reminder Queue
# -----------------------------
elif page == "Reminder Queue":
    st.subheader("Medication Reminder Queue")

    df = run_query("""
        SELECT
            log_id,
            patient_id,
            first_name,
            last_name,
            prescription_id,
            medicine_name,
            scheduled_time,
            status,
            reminder_type,
            reminder_message
        FROM MART_MEDICATION_REMINDER_QUEUE
        ORDER BY scheduled_time DESC
        LIMIT 200
    """)

    st.dataframe(df, use_container_width=True)

# -----------------------------
# Refill Recommendations
# -----------------------------
elif page == "Refill Recommendations":
    st.subheader("Nearest Pharmacy Refill Recommendations")

    df = run_query("""
        SELECT
            prescription_id,
            patient_id,
            medicine_name,
            refill_status,
            days_remaining,
            pharmacy_id,
            pharmacy_name,
            stock_quantity,
            price,
            distance_miles
        FROM MART_NEAREST_REFILL_OPTIONS
        ORDER BY days_remaining ASC, distance_miles ASC
        LIMIT 200
    """)

    st.dataframe(df, use_container_width=True)

# -----------------------------
# Refill Messages
# -----------------------------
elif page == "Refill Messages":
    st.subheader("Generated Refill Messages")

    df = run_query("""
        SELECT
            prescription_id,
            patient_id,
            medicine_name,
            refill_status,
            days_remaining,
            pharmacy_name,
            distance_miles,
            price,
            refill_message
        FROM MART_REFILL_MESSAGES
        ORDER BY days_remaining ASC
        LIMIT 100
    """)

    st.dataframe(df, use_container_width=True)

# -----------------------------
# High-Risk Patients
# -----------------------------
elif page == "High-Risk Patients":
    st.subheader("High-Risk Patients / Prescriptions")

    df = run_query("""
        SELECT
            patient_id,
            first_name,
            last_name,
            prescription_id,
            medicine_name,
            drug_class,
            ROUND(adherence_rate * 100, 2) AS adherence_percentage,
            doses_missed,
            doses_skipped,
            adherence_risk
        FROM MART_PATIENT_ADHERENCE
        WHERE adherence_risk = 'High Risk'
        ORDER BY adherence_rate ASC
        LIMIT 200
    """)

    st.dataframe(df, use_container_width=True)