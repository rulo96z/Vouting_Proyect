



###### Still needs a lot of work. Just putting together a littl bit of an outline. Feel free to edit #######


from secrets import token_bytes
from coincurve import PublicKey
from sha3 import keccak_256
import time
import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

load_dotenv()

# Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))

# Cache the contract on load
@st.cache(allow_output_mutation=True)

# Define the load_contract function
def load_contract():

    # Load Voting ABI
    with open(Path('contracts/compiled/votingApp_abi.json')) as f:
        voting_abi = json.load(f)
    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("SMART_CONTRACT_ADDRESS")
    # Get the contract
    contract = w3.eth.contract(
    address = w3.toChecksumAddress(contract_address),
    abi = voting_abi)

    # Return the contract from the function
    return contract
contract = load_contract()

#Streamlit Title

st.title('Decentralized Voting Application')
st.image("https://github.com/rulo96z/Vouting_Proyect/blob/master/image/Eii7lfJWAAEQJ-n.png?raw=True")

#########################KYC Form##################################

with st.expander("KYC Form"):
    st.subheader("KYC Form")
    st.text_input("Full Name")
    st.text_input("Age")
    st.text_input("Mailing Address")
    st.text_input("Social Security Number")
    st.camera_input("Take a picture")
    if st.button("Generate Voter Wallet"):
        private_key = keccak_256(token_bytes(32)).digest()
        public_key = PublicKey.from_valid_secret(private_key).format(compressed=False)[1:]
        addr = keccak_256(public_key).digest()[-20:]
        st.write('private_key:', private_key.hex())
        st.write('eth addr: 0x' + addr.hex())

#########################Validate##################################
with st.expander("Voter Validation"):
    st.subheader("Voter Validation")
    voter_adddress = st.text_input("Voter Address")
    voter_name = st.text_input("Voter Name")
    voter_age = st.text_input("Voter Age")
    form = (f"{voter_adddress}{voter_name}{voter_age}")
    if st.button("Validate"):
        contract.functions.registerVoter(form).transact({'from': voter_adddress, 'gas': 1000000})
        with st.spinner(text="Processing Voter Registration Validation"):
                time.sleep(5)
                st.write("Congratulations! You have been Validated to Vote!")
                st.balloons()

#########################Vote##################################

with st.expander("Vote For Your Candidate"):
    st.empty()
    st.title("Vote For Your Candidate")
    candidate1 = contract.functions.getName(1).call()
    candidate2 = contract.functions.getName(2).call()
    candidate3 = contract.functions.getName(3).call()
    candidates = (f"{candidate1}, {candidate2}, {candidate3}")
    
    #create columns
    col1, col2, col3, col4 = st.columns(4)

    with col1:
        st.header(candidate1)
        st.image("https://thumbs.dreamstime.com/b/bowl-tasty-chocolate-ice-cream-mint-isolated-white-153699785.jpg")
        if st.button("Pick Chocolate"):
            contract.functions.vote(1).transact({'from': voter_adddress, 'gas': 1000000})
            st.write("You have chosen Chocolate")

    with col2:
        st.header(candidate2)
        st.image("https://www.madewithnestle.ca/sites/default/files/nestle_vanillabean01_copy.png")
        if st.button("Pick Vanilla"):
            contract.functions.vote(2).transact({'from': voter_adddress, 'gas': 1000000})
            st.write("You have chosen Vanilla")

    with col3:
        st.header(candidate3)
        st.image("https://thumbs.dreamstime.com/b/scoops-delicious-strawberry-ice-cream-fresh-berries-white-background-153933844.jpg")
        if st.button("Pick Strawberry"):
            contract.functions.vote(3).transact({'from': voter_adddress, 'gas': 1000000})
            st.write("You have chosen Strawberry")

####################Visualize Voting Results########################
st.header("Voting Results")
candidate1_results = contract.functions.getVoteCount(1).call()
candidate2_results = contract.functions.getVoteCount(2).call()
candidate3_results = contract.functions.getVoteCount(3).call()
df=pd.DataFrame({"Index":[candidate1,candidate2,candidate3], "Results":[candidate1_results,candidate2_results,candidate3_results]}).set_index(["Index"])
st.bar_chart(df, width=600, height=240)

