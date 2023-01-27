// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract EMR {

    struct Record {
        string cid;
        string fileName;
        address patientId;
        address doctorId;
        uint256 timeAdded;
    }

    struct Patient {
        address id;
        Record[] records;
    }

    struct Doctor {
        address id;
    }

    mapping (address => Patient) public patients;
    mapping (address => Doctor) public doctors;

    event patientAdded(address patientId);
    event doctorAdded(address doctorId);
    event recordAdded(string cid, address patientId, address doctorId);

    modifier senderExists(address patientId) {
        require (patients[patientId].id == patientId, "Patient does not exist");
        _;
    }

    modifier patientExists(address patientId) {
        require(patients[patientId].id == msg.sender, "Sender is not a doctor");
        _;
    }

    modifier senderIsDoctor {
        require (doctors[msg.sender].id == msg.sender, "Sender is not a doctor");
        _;
    }

    function addPatient(address _patientId) public senderIsDoctor {
        require(patients[_patientId].id != _patientId, "This patient already exists.");
        patients[_patientId].id = _patientId;

        emit doctorAdded(msg.sender);
    }

    function getRecords(address _patientId) public view senderExists patientExists(_patientId) returns (Record[] memory) {
        return patients[_patientId].records;
  } 

    function getSenderRole() public view returns (string memory) {
        if (doctors[msg.sender].id == msg.sender) {
        return "doctor";
        } else if (patients[msg.sender].id == msg.sender) {
        return "patient";
        } else {
        return "unknown";
        }
  }

    function getPatientExists(address _patientId) public view senderIsDoctor returns (bool) {
        return patients[_patientId].id == _patientId;
  }

}