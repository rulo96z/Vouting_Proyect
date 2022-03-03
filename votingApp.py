



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
        address = w3.toChecksumAddress(contract_address),
        abi = voting_abi
    )
    # Return the contract from the function
    votacion = contract.functions.registerVoter().call()
    return votacion

#Streamlit Title
st.title('Decentralized Voting Application')
st.image("https://github.com/rulo96z/Vouting_Proyect/blob/master/image/Eii7lfJWAAEQJ-n.png?raw=True")

# Registration form for participants 
form = st.form("The Form")
with form:
    c1, c2, c3, c4 = st.columns(4)
    with c1:
        full_name = form.text_input("Full Name")
    with c2:
        email = form.text_input("Email")
    with c3:
        number_phone = form.text_input("Number Phone")
    with c4:
        nationality = form.text_input("Nationality")
# Checkbox function for use with candidates
    selector = st.selectbox("Vote for your favorate flavor", ['Chocolate', 'Vanilla', 'Mango', 'Strawberry'])
    submitted = st.form_submit_button("Submit")
    #if submitted: HERE WE NEED TO DELEVOP FARTHER I GOT STOCK! 


# Load the contract
mint_contract = load_contract()
voting_contract = load_contract()

### Award VotingToken

voter_accounts = w3.eth.accounts

#Mint Voting token
voter_account = st.text_input("Input Personal Voting Address ", value=voter_accounts)
if st.button("Mint VoteToken"):
    mint_contract.functions.AwardVoteToken(voter_account).transact({'from': mint_address, 'gas': 1000000})

