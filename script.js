


const connectWalletBtn = document.getElementById("connectWallet");
const signMessageBtn = document.getElementById("signMessage");
const confirmationDiv = document.getElementById("confirmation");
let web3;

// Check for MetaMask
if (typeof window.ethereum === "undefined") {
  connectWalletBtn.innerText = "Install MetaMask";
  connectWalletBtn.disabled = true;
}

// Connect to wallet
async function connectWallet() {
  try {
    if (web3) {
      // Disconnect logic (optional UI reset)
      connectWalletBtn.innerText = "Connect Wallet";
      web3 = null;
      signMessageBtn.disabled = true;
      confirmationDiv.innerText = "";
    } else {
      await window.ethereum.request({ method: "eth_requestAccounts" });
      web3 = new Web3(window.ethereum);
      connectWalletBtn.innerText = "Wallet Connected";
      signMessageBtn.disabled = false;
    }
  } catch (error) {
    console.error("Error connecting wallet:", error);
  }
}

// Sign a message
async function signMessage() {
  try {
    if (!web3) {
      alert("Connect your wallet first.");
      return;
    }
    const accounts = await web3.eth.getAccounts();
    const message = "Hello, PolyPaws!";
    const signature = await web3.eth.personal.sign(message, accounts[0]);
    confirmationDiv.innerText = `Signed message: ${signature}`;
  } catch (error) {
    console.error("Error signing message:", error);
  }
}

connectWalletBtn.addEventListener("click", connectWallet);
signMessageBtn.addEventListener("click", signMessage);
