
# HotelBooking Smart Contract

A decentralized application (dApp) for managing hotel room bookings, built on Ethereum using Solidity and Hardhat. This smart contract ensures secure and transparent processes for room bookings, check-ins, check-outs, and reviews.

---

## Table of Contents

- [Features](#features)
- [Technologies](#technologies)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Contract Functions](#contract-functions)
- [Example Workflow](#example-workflow)
- [License](#license)
- [Contributing](#contributing)
- [Contact](#contact)

---

## Features

- **Room Management**: Add and manage hotel rooms with customizable categories (e.g., Royal, Premium, Deluxe).
- **Booking System**: Customers can book rooms by paying the required tariff in Ether.
- **Check-In/Check-Out**: Streamlined and secure check-in and check-out processes.
- **Review System**: Customers can leave reviews and ratings for rooms post check-out.
- **Access Control**: Only the contract owner can add or modify rooms.

---

## Technologies

- **Solidity**: Smart contract programming language.
- **Hardhat**: Ethereum development environment for compiling, testing, and deploying smart contracts.
- **Ethers.js**: Library for interacting with the Ethereum blockchain.
- **Chai**: Assertion library for writing unit tests.
- **Infura**: Ethereum node provider for connecting to the Sepolia testnet.

---

## Prerequisites

Ensure the following tools are installed before running the project:

- [Node.js](https://nodejs.org/) (v14.x, v16.x, v18.x, or v20.x)
- [npm](https://www.npmjs.com/) (comes with Node.js)
- [Hardhat](https://hardhat.org/)

---

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/codebasebo/hotel-booking-contract.git
   cd hotel-booking
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

---

## Configuration

1. Create a `.env` file in the root directory and add the following variables:
   ```dotenv
   INFURA_PROJECT_ID=your-infura-project-id
   PRIVATE_KEY=your-private-key
   ```

2. Update the `hardhat.config.js` file with your Infura Project ID and private key:
   ```javascript
   require("@nomicfoundation/hardhat-toolbox");
   require("dotenv").config();

   module.exports = {
     solidity: "0.8.20",
     networks: {
       localhost: {
         url: "http://127.0.0.1:8545",
       },
       sepolia: {
         url: `https://sepolia.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
         accounts: [process.env.PRIVATE_KEY],
       },
     },
   };
   ```

---

## Usage

### Compile the Contract
Compile the smart contract:
```bash
npx hardhat compile
```

### Run Tests
Run the test suite to ensure the contract functions as expected:
```bash
npx hardhat test
```

### Deploy the Contract
Deploy the contract to a local network:
```bash
npx hardhat run scripts/deploy.js --network localhost
```

Deploy the contract to the Sepolia testnet:
```bash
npx hardhat run scripts/deploy.js --network sepolia
```

---

## Contract Functions

- **`setHotelRoom(uint256 roomId, string memory category, uint256 tariff)`**  
  Add a new hotel room (owner-only).

- **`setCustomer(address customerAddress)`**  
  Register a new customer.

- **`payToBook(uint256 roomId)`**  
  Book a room by paying the specified tariff.

- **`checkIn(uint256 roomId)`**  
  Check into a booked room.

- **`checkOut(uint256 roomId, uint8 rating)`**  
  Check out of a room and leave a review (1–5 star rating).

---

## Example Workflow

1. **Add Rooms** (Owner-only):
   ```javascript
   await hotelBooking.setHotelRoom(1, "Royal", 10); // Room ID: 1, Category: Royal, Tariff: 10 Ether
   ```

2. **Book a Room**:
   ```javascript
   await hotelBooking.payToBook(1, { value: ethers.parseEther("10") }); // Pay 10 Ether to book Room ID: 1
   ```

3. **Check In**:
   ```javascript
   await hotelBooking.checkIn(1); // Check into Room ID: 1
   ```

4. **Check Out**:
   ```javascript
   await hotelBooking.checkOut(1, 5); // Check out and leave a 5-star review for Room ID: 1
   ```

---

## License

This project is licensed under the [MIT License](./LICENSE).

---

## Contributing

Contributions are welcome! Follow these steps to contribute:

1. Fork the repository.
2. Create a new branch:  
   ```bash
   git checkout -b feature/YourFeature
   ```
3. Commit your changes:  
   ```bash
   git commit -m 'Add some feature'
   ```
4. Push to the branch:  
   ```bash
   git push origin feature/YourFeature
   ```
5. Open a pull request.



