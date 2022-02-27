



###### Still needs a lot of work. Just putting together a littl bit of an outline. Feel free to edit #######



import os
import json
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st

load_dotenv()

# Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))


### Loads the contract once using cache
### Connects to the contract using the contract address and ABI


# Cache the contract on load
@st.cache(allow_output_mutation=True)

# Define the load_contract function
def load_contract():

    # Load Voting ABI
    with open(Path()) as f:
        voting_abi = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("SMART_CONTRACT_ADDRESS")

    # Get the contract
    contract = w3.eth.contract(
        address=contract_address,
        abi=voting_abi
    )
    # Return the contract from the function
    return contract

#Streamlit Title
st.title('Decentralized Voting Application')

# Load the contract
mint_contract = load_contract()
voting_contract = load_contract()

### Award VotingToken

voter_accounts = w3.eth.accounts

#Mint Voting token
voter_account = st.text_input("Input Personal Voting Address ", value=voter_accounts)
if st.button("Mint VoteToken"):
        mint_contract.functions.AwardVoteToken(voter_account).transact({'from': mint_address, 'gas': 1000000})
