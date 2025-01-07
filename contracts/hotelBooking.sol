// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

/**
 * @title HotelBooking
 * @dev A smart contract for managing hotel room bookings, check-ins, check-outs, and reviews.
 */
contract HotelBooking {
    struct HotelRoom {
        string categoryName; // Name of the room category (e.g., Royal, Premium, Deluxe)
        uint tariff;         // Price per night in Ether
        bool occupied;       // Whether the room is currently occupied
        uint review;         // Average review score
        uint reviewNo;       // Number of reviews
        address customerBooked; // Address of the customer who booked the room
        bool booked;         // Whether the room is booked
    }

    struct Customer {
        string name;         // Name of the customer
        string addre;        // Address of the customer
        uint custIdNo;       // Unique customer ID
    }

    uint private custCount;  // Total number of customers
    uint private noOfRooms;  // Total number of rooms
    address public owner;    // Address of the contract owner

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    mapping(uint => HotelRoom) public hotelRoomDetails; // Mapping of room numbers to room details
    mapping(address => Customer) public customerDetails; // Mapping of customer addresses to customer details

    // Events
    event RoomBooked(uint roomNo, address customer);
    event CheckedIn(uint roomNo, address customer);
    event CheckedOut(uint roomNo, address customer, uint rating);
    event RoomAdded(uint roomNo, string categoryName, uint tariff);
    event CustomerRegistered(address customer, string name, string addre);

    /**
     * @dev Constructor to initialize the contract and set the owner.
     * Adds initial rooms to the hotel.
     */
    constructor() {
        owner = msg.sender;
        setHotelRoom(1, "Royal", 10);
        setHotelRoom(2, "Premium", 5);
        setHotelRoom(3, "Deluxe", 3);
    }

    /**
     * @dev Adds a new hotel room.
     * @param _roomNo The room number.
     * @param _categoryName The category name of the room (e.g., Royal, Premium, Deluxe).
     * @param _tariff The price per night in Ether.
     */
    function setHotelRoom(uint _roomNo, string memory _categoryName, uint _tariff) public onlyOwner {
        hotelRoomDetails[_roomNo] = HotelRoom({
            categoryName: _categoryName,
            tariff: _tariff,
            occupied: false,
            review: 0,
            reviewNo: 0,
            customerBooked: address(0),
            booked: false
        });
        noOfRooms++;
        emit RoomAdded(_roomNo, _categoryName, _tariff);
    }

    /**
     * @dev Registers a new customer.
     * @param _addr The address of the customer.
     * @param _name The name of the customer.
     * @param _addre The address of the customer.
     */
    function setCustomer(address _addr, string memory _name, string memory _addre) public {
        customerDetails[_addr] = Customer({
            name: _name,
            addre: _addre,
            custIdNo: custCount
        });
        custCount++;
        emit CustomerRegistered(_addr, _name, _addre);
    }

    /**
     * @dev Allows a customer to book a room by paying the correct amount.
     */
    function payToBook() public payable {
        if (msg.value == 10 ether) {
            bookRoom(1);
        } else if (msg.value == 5 ether) {
            bookRoom(2);
        } else if (msg.value == 3 ether) {
            bookRoom(3);
        } else {
            revert("Incorrect payment amount");
        }
    }

    /**
     * @dev Internal function to book a room.
     * @param _roomNo The room number to book.
     */
    function bookRoom(uint _roomNo) internal {
        require(!hotelRoomDetails[_roomNo].booked, "Room is already booked");
        hotelRoomDetails[_roomNo].booked = true;
        hotelRoomDetails[_roomNo].customerBooked = msg.sender;
        emit RoomBooked(_roomNo, msg.sender);
    }

    /**
     * @dev Allows a customer to check into a booked room.
     * @param _roomNo The room number to check into.
     */
    function checkIn(uint _roomNo) external {
        require(hotelRoomDetails[_roomNo].customerBooked == msg.sender, "This room has not been booked by you.");
        hotelRoomDetails[_roomNo].occupied = true;
        emit CheckedIn(_roomNo, msg.sender);
    }

    /**
     * @dev Allows a customer to check out of a room and leave a review.
     * @param _roomNo The room number to check out of.
     * @param _rating The review rating (1-5).
     */
    function checkOut(uint _roomNo, uint _rating) external {
        require(hotelRoomDetails[_roomNo].customerBooked == msg.sender, "This room has not been booked by you.");
        require(_rating >= 1 && _rating <= 5, "Rating must be between 1 and 5");

        hotelRoomDetails[_roomNo].occupied = false;
        hotelRoomDetails[_roomNo].booked = false;
        hotelRoomDetails[_roomNo].review = (_rating + (hotelRoomDetails[_roomNo].review * hotelRoomDetails[_roomNo].reviewNo)) / (hotelRoomDetails[_roomNo].reviewNo + 1);
        hotelRoomDetails[_roomNo].reviewNo++;
        emit CheckedOut(_roomNo, msg.sender, _rating);
    }
}