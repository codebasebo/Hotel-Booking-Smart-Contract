const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("HotelBooking", function () {
  async function deployHotelBooking() {
    const [owner, customer] = await ethers.getSigners();

    const HotelBooking = await ethers.getContractFactory("HotelBooking");
    const hotelBooking = await HotelBooking.deploy();
    await hotelBooking.waitForDeployment();

    const hotelBookingAddr = await hotelBooking.getAddress();
    console.log("HotelBooking deployed to:", hotelBookingAddr);

    return { owner, customer, hotelBooking };
  }

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      const { owner, hotelBooking } = await deployHotelBooking();
      expect(await hotelBooking.owner()).to.equal(owner.address);
    });
  });

  describe("setHotelRoom", function () {
    it("Should set the hotel room", async function () {
      const { owner, hotelBooking } = await deployHotelBooking();

      const roomNo = 1;
      const categoryName = "Royal";
      const tariff = 10;

      await hotelBooking.connect(owner).setHotelRoom(roomNo, categoryName, tariff);

      const room = await hotelBooking.hotelRoomDetails(roomNo);
      expect(room.categoryName).to.equal(categoryName);
      expect(room.tariff).to.equal(tariff);
    });

    it("Should fail if not owner", async function () {
      const { customer, hotelBooking } = await deployHotelBooking();

      const roomNo = 1;
      const categoryName = "Royal";
      const tariff = 10;

      await expect(hotelBooking.connect(customer).setHotelRoom(roomNo, categoryName, tariff)).to.be.revertedWith("Only owner can perform this action");
    });
  });
  describe("payToBook", function () {
    it("Should book the room if correct payment is made", async function () {
      const { customer, hotelBooking } = await deployHotelBooking();

      const roomNo = 1;
      const paymentAmount = ethers.parseEther("10");

      await expect(hotelBooking.connect(customer).payToBook({ value: paymentAmount }))
        .to.emit(hotelBooking, "RoomBooked")
        .withArgs(roomNo, customer.address);

      const room = await hotelBooking.hotelRoomDetails(roomNo);
      expect(room.booked).to.be.true;
      expect(room.customerBooked).to.equal(customer.address);
    });

    it("Should fail if incorrect payment is made", async function () {
      const { customer, hotelBooking } = await deployHotelBooking();

      const incorrectPaymentAmount = ethers.parseEther("1");

      await expect(hotelBooking.connect(customer).payToBook({ value: incorrectPaymentAmount })).to.be.revertedWith("Incorrect payment amount");
    });
  });

  describe("checkIn and checkOut", function () {
    it("Should allow customer to check in and check out", async function () {
      const { customer, hotelBooking } = await deployHotelBooking();

      const roomNo = 1;
      const paymentAmount = ethers.parseEther("10");
      const rating = 5;

      await hotelBooking.connect(customer).payToBook({ value: paymentAmount });

      await expect(hotelBooking.connect(customer).checkIn(roomNo))
        .to.emit(hotelBooking, "CheckedIn")
        .withArgs(roomNo, customer.address);

      let room = await hotelBooking.hotelRoomDetails(roomNo);
      expect(room.occupied).to.be.true;

      await expect(hotelBooking.connect(customer).checkOut(roomNo, rating))
        .to.emit(hotelBooking, "CheckedOut")
        .withArgs(roomNo, customer.address, rating);

      room = await hotelBooking.hotelRoomDetails(roomNo);
      expect(room.occupied).to.be.false;
      expect(room.booked).to.be.false;
      expect(room.review).to.equal(rating);
      expect(room.reviewNo).to.equal(1);
    });
  });
})
