const { ethers } = require("hardhat");

async function main() {
    // Get the contract factory
    const HotelBooking = await ethers.getContractFactory("HotelBooking");

    // Deploy the contract
    console.log("Deploying HotelBooking contract...");
    const hotelBooking = await HotelBooking.deploy();

    // Wait for the contract to be deployed
    await hotelBooking.waitForDeployment();

    // Get the contract address
    const hotelBookingAddress = await hotelBooking.getAddress();
    console.log("HotelBooking deployed to:", hotelBookingAddress);

    // Optional: Log the transaction hash
    const deploymentTransaction = hotelBooking.deploymentTransaction();
    console.log("Transaction hash:", deploymentTransaction.hash);
}

// Run the deployment script
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error("Error deploying contract:", error);
        process.exit(1);
    });