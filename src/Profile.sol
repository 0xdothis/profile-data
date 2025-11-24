// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Profile contract
/// @notice You can use this contract to set a user and edit
/// @dev This contract utilize ways to save gas and unncecssary storage reads
contract Profile {
    /// @notice custom error for profile not yet set
    error ProfileNotSet();

    /// @notice event to keep track of changes in name and age
    event ProfileUpdated(bool nameChanged, bool ageChanged);

    /// @notice A struct of ProfileData
    struct ProfileData {
        string name;
        uint16 age;
    }

    /// @notice creating a private variable of type ProfileData
    /// @dev private keyword to keep user data secure

    ProfileData private profile;

    /// @notice Set a new user to the profile
    /// @dev using calldata to help save gas cost and ensure input can't be manipulated
    /// @param name A string to be assign to the name
    /// @param age A uint to be assign to the age

    function setProfile(string calldata name, uint16 age) external {
        profile = ProfileData({name: name, age: age});
    }

    /// @notice Function to return a profile
    /// @dev uses storage to mutate the state
    /// @return A string showing the name
    /// @return A uint showing the age

    function getProfile() external view returns (string memory, uint16) {
        ProfileData storage _profile = profile;

        return (_profile.name, _profile.age);
    }

    /// @notice change current name to new name
    /// @dev uses meomry to copy data from storage
    /// @param newName an argument to change the current name

    function renameProfileMemory(string memory newName) external view {
        ProfileData memory _profile = profile;

        _profile.name = newName;
    }

    /// @notice Rename a user profile name
    /// @dev mutates the storgae state
    /// @param newName the new value to write to storage
    function renameProfileStorage(string calldata newName) external {
        ProfileData storage _profile = profile;

        _profile.name = newName;
    }

    /// @notice Preview the previous name after changes has been made
    /// @dev copy from storage to memory and mutate the value in memory
    /// @param newName The new name to be set
    /// @return storedName A string from storage
    /// @return previewName A string from memory
    function previewRename(string calldata newName)
        external
        view
        returns (string memory storedName, string memory previewName)
    {
        ProfileData memory _profile = profile;
        _profile.name = newName;

        return (profile.name, _profile.name);
    }

    /// @notice Make changes to the value if the are different
    /// @dev Trying as much as possible to reduce gas cost by not performing an SLOAD when not needed
    /// @param newName The new name to be set
    /// @param newAge The new age to be set
    /// @return updated A bool to indicate if a state was mutated or not
    function updateProfileIfDifferent(string calldata newName, uint16 newAge) external returns (bool updated) {
        ProfileData storage _profile = profile;
        string storage name = _profile.name;
        uint16 age = _profile.age;

        bool nameChanged = keccak256(bytes(name)) != keccak256(bytes(newName));
        bool ageChanged = age != newAge;

        if (!nameChanged && !ageChanged) {
            return false;
        }

        if (nameChanged) {
            _profile.name = newName;
        }

        if (ageChanged) {
            _profile.age = newAge;
        }

        emit ProfileUpdated(nameChanged, ageChanged);
        return true;
    }

    /// @notice get a user profile in a safe way
    /// @dev making sure a user is only returned if a user has been created
    /// @return A string copied from storage to memory
    /// @return age of the user returned

    function safeGetProfile() external view returns (string memory, uint16) {
        if (bytes(profile.name).length == 0) {
            revert ProfileNotSet();
        }

        return (profile.name, profile.age);
    }
}
