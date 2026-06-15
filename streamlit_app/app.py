import streamlit as st
from pathlib import Path

st.set_page_config(page_title="MedSync AI — Demo")
st.title("MedSync AI — Snowflake PoC")

root = Path(__file__).resolve().parents[1]
st.markdown("This is a simple demo scaffold. Run the data generation scripts in `src/` to create sample data.")

if st.button("Show sample files"):
    p = root / 'data' / 'sample'
    files = list(p.glob('*')) if p.exists() else []
    if files:
        for f in files:
            st.write(f.name)
    else:
        st.info("No sample files found. Run `python src/generate_data.py`.")
