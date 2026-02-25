// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CarbonRegistry {
    // ── State ────────────────────────────────────────────────────────────
    address public admin;
    uint256 public projectCount;
    uint256 public creditCount;

    struct Project {
        uint256 id;
        string name;
        address owner;
        bool verified;
    }

    struct Credit {
        uint256 id;
        uint256 projectId;
        uint256 amount; // tonnes of CO₂
        address owner;
        bool retired;
    }

    mapping(uint256 => Project) public projects;
    mapping(uint256 => Credit) public credits;

    // ── Events ───────────────────────────────────────────────────────────
    event ProjectRegistered(uint256 indexed projectId, string name, address indexed owner);
    event ProjectVerified(uint256 indexed projectId);
    event CreditIssued(uint256 indexed creditId, uint256 indexed projectId, uint256 amount, address indexed owner);
    event CreditRetired(uint256 indexed creditId, address indexed retiredBy);

    // ── Modifiers ────────────────────────────────────────────────────────
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    // ── Constructor ──────────────────────────────────────────────────────
    constructor() {
        admin = msg.sender;
    }

    // ── Project functions ────────────────────────────────────────────────

    /// @notice Anyone can register a new carbon-offset project.
    function registerProject(string calldata _name) external {
        projectCount++;
        projects[projectCount] = Project({
            id: projectCount,
            name: _name,
            owner: msg.sender,
            verified: false
        });
        emit ProjectRegistered(projectCount, _name, msg.sender);
    }

    /// @notice Admin verifies a registered project.
    function verifyProject(uint256 _projectId) external onlyAdmin {
        require(_projectId > 0 && _projectId <= projectCount, "Project does not exist");
        require(!projects[_projectId].verified, "Project already verified");

        projects[_projectId].verified = true;
        emit ProjectVerified(_projectId);
    }

    // ── Credit functions ─────────────────────────────────────────────────

    /// @notice Admin issues carbon credits for a verified project.
    function issueCredit(uint256 _projectId, uint256 _amount, address _to) external onlyAdmin {
        require(_projectId > 0 && _projectId <= projectCount, "Project does not exist");
        require(projects[_projectId].verified, "Project is not verified");
        require(_amount > 0, "Amount must be greater than zero");

        creditCount++;
        credits[creditCount] = Credit({
            id: creditCount,
            projectId: _projectId,
            amount: _amount,
            owner: _to,
            retired: false
        });
        emit CreditIssued(creditCount, _projectId, _amount, _to);
    }

    /// @notice The credit owner permanently retires (burns) a credit.
    function retireCredit(uint256 _creditId) external {
        require(_creditId > 0 && _creditId <= creditCount, "Credit does not exist");
        Credit storage credit = credits[_creditId];
        require(msg.sender == credit.owner, "Only credit owner can retire");
        require(!credit.retired, "Credit already retired");

        credit.retired = true;
        emit CreditRetired(_creditId, msg.sender);
    }

    // ── View helpers ─────────────────────────────────────────────────────

    /// @notice Returns full project details.
    function getProject(uint256 _projectId) external view returns (Project memory) {
        require(_projectId > 0 && _projectId <= projectCount, "Project does not exist");
        return projects[_projectId];
    }

    /// @notice Returns full credit details.
    function getCredit(uint256 _creditId) external view returns (Credit memory) {
        require(_creditId > 0 && _creditId <= creditCount, "Credit does not exist");
        return credits[_creditId];
    }
}