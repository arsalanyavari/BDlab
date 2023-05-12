-------------------------------------------------------------------------------------- Create Database

CREATE DATABASE SocialMedia
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SocialMedia', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\SocialMedia.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SocialMedia_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\SocialMedia_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

-----------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------- Create Tables 
USE SocialMedia
GO

CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
	Password VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    ProfilePicture VARBINARY(MAX),
    RegistrationDate DATETIME
);

-- 

USE SocialMedia
GO

CREATE TABLE UserProfile (
    UserID INT PRIMARY KEY,
    AboutMe VARCHAR(MAX),
    Location VARCHAR(100),
    Education VARCHAR(100),
    Occupation VARCHAR(100),
    Interests VARCHAR(100),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

--

USE SocialMedia
GO

-- DROP TABLE Posts;

CREATE TABLE Posts (
    PostID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    PostContent VARCHAR(MAX),
    PostType VARCHAR(20),
    PostDate DATETIME NOT NULL 
);

--

USE SocialMedia
GO

CREATE TABLE Comments (
    CommentID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    PostID INT FOREIGN KEY REFERENCES Posts(PostID),
    CommentText NVARCHAR(MAX) NOT NULL,
    CommentDate DATETIME NOT NULL
);

--

USE SocialMedia
GO

CREATE TABLE Likes (
    LikeID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    PostID INT FOREIGN KEY REFERENCES Posts(PostID),
    LikeDate DATETIME NOT NULL
);

--

USE SocialMedia
GO

CREATE TABLE Groups (
    GroupID INT IDENTITY(1,1) PRIMARY KEY,
    GroupName VARCHAR(100) NOT NULL,
	GroupDescription VARCHAR(MAX),
    GroupOwnerID INT FOREIGN KEY REFERENCES Users(UserID),
    CreationDate DATETIME NOT NULL
);

--

USE SocialMedia
GO

CREATE TABLE GroupMembers (
    GroupID INT FOREIGN KEY REFERENCES Groups(GroupID),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    JoinDate DATETIME NOT NULL,
    MemberRole VARCHAR(50) NOT NULL
);

--

USE SocialMedia
GO

CREATE TABLE Friendships (
    FriendshipID INT PRIMARY KEY,
    UserID1 INT FOREIGN KEY REFERENCES Users(UserID),
    UserID2 INT FOREIGN KEY REFERENCES Users(UserID),
    FriendshipDate DATETIME NOT NULL,
    Status VARCHAR(50) NOT NULL DEFAULT 'pending',
    LastInteractionDate DATETIME,
	FriendshipType VARCHAR(50)	NOT NULL, 
    BlockedBy INT FOREIGN KEY REFERENCES Users(UserID),
    UnfriendDate DATETIME
);

--

USE SocialMedia
GO

CREATE TABLE PrivacySettings (
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    WhoCanViewProfile VARCHAR(50) NOT NULL DEFAULT 'Everyone',
    WhoCanContactUser VARCHAR(50) NOT NULL DEFAULT 'Friends',
    WhoCanSeePosts VARCHAR(50) NOT NULL DEFAULT 'Friends',
    PRIMARY KEY (UserID)
);

-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------  Insert sample data to tables

INSERT INTO Users (FirstName, LastName, Email, Password, DateOfBirth, ProfilePicture, RegistrationDate) 
VALUES ('Amir Arsalan', 'Yavari', 'arya48.yavari@gmail.com', 'password123', '2000-11-05', NULL, GETDATE());

INSERT INTO Users (FirstName, LastName, Email, Password, DateOfBirth, ProfilePicture, RegistrationDate) 
VALUES ('Adrian', 'Season', 'AdrianSeasonh@gmail.com', 'password456', '2022-07-13', NULL, GETDATE());

INSERT INTO Users (FirstName, LastName, Email, Password, DateOfBirth, ProfilePicture, RegistrationDate) 
VALUES ('Andre', 'Johnson', 'Andrejohnson@gmail.com', 'securepass789', '2018-11-03', NULL, GETDATE());

--

INSERT INTO UserProfile(UserID, AboutMe, Location, Education, Occupation, Interests)
VALUES (1, 'I love play with linux and shell.', 'Isfahan', 'B.A. Computer Science', 'Computer Student at IUT.', 'Hiking, reading, music');

INSERT INTO UserProfile(UserID, AboutMe, Location, Education, Occupation, Interests)
VALUES (2, 'Travel enthusiast and foodie.', 'Los Angeles', 'B.A. Computer Science', 'nothing :)', 'Cooking, traveling, photography');

INSERT INTO UserProfile(UserID, AboutMe, Location, Education, Occupation, Interests)
VALUES (3, 'Passionate about gaming and technology', 'Tokyo', 'B.A. Computer Science', 'Cloud Admin Engineer at Amazon', 'Gaming, technology, coding');

--

INSERT INTO Posts(UserID, PostContent, PostType, PostDate)
VALUES (1, 'Just went on a beautiful hike in the Sofe mountain', 'photo', GETDATE());

INSERT INTO Posts(UserID, PostContent, PostType, PostDate)
VALUES (2, 'Had an amazing dinner at the new restaurant!', 'text', GETDATE());

INSERT INTO Posts(UserID, PostContent, PostType, PostDate)
VALUES (3, 'Excited to work on a new project at Amazon!', 'text', GETDATE());

--

INSERT INTO Comments(UserID, PostID, CommentText, CommentDate)
VALUES (1, 1, 'Wow, that view look likes amazing =)', GETDATE());

INSERT INTO Comments(UserID, PostID, CommentText, CommentDate)
VALUES (2, 2, 'I need to check out that restaurant :)', GETDATE());

INSERT INTO Comments(UserID, PostID, CommentText, CommentDate)
VALUES (3, 3, 'Can''t wait to hear more about your project ...', GETDATE());

--

INSERT INTO Likes(UserID, PostID, LikeDate)
VALUES (1, 1, GETDATE());

INSERT INTO Likes(UserID, PostID, LikeDate)
VALUES (2, 1, GETDATE());

INSERT INTO Likes(UserID, PostID, LikeDate)
VALUES (3, 2, GETDATE());

--

INSERT INTO Groups(GroupName, GroupDescription, GroupOwnerID, CreationDate)
VALUES ('Hiking Enthusiasts', 'A group for people who love hiking!', 1, GETDATE());

INSERT INTO Groups(GroupName, GroupDescription, GroupOwnerID, CreationDate)
VALUES ('Foodies Unite', '', 2, GETDATE());

INSERT INTO Groups(GroupName, GroupDescription, GroupOwnerID, CreationDate)
VALUES ('Tech Geeks', 'A group for tech enthusiasts', 3, GETDATE());

--

INSERT INTO GroupMembers(GroupID, UserID, JoinDate, MemberRole)
VALUES (1, 1, GETDATE(), 'admin');

INSERT INTO GroupMembers(GroupID, UserID, JoinDate, MemberRole)
VALUES (1, 2, GETDATE(), 'member');

INSERT INTO GroupMembers(GroupID, UserID, JoinDate, MemberRole)
VALUES (1, 3, GETDATE(), 'member');

INSERT INTO GroupMembers(GroupID, UserID, JoinDate, MemberRole)
VALUES (2, 1, GETDATE(), 'admin');

--

INSERT INTO Friendships(FriendshipID, UserID1, UserID2, FriendshipDate, Status, LastInteractionDate, FriendshipType, BlockedBy, UnfriendDate)
VALUES (1, 1, 2, GETDATE(), 'pending', NULL, 'regular', NULL, NULL);

INSERT INTO Friendships(FriendshipID, UserID1, UserID2, FriendshipDate, Status, LastInteractionDate, FriendshipType, BlockedBy, UnfriendDate)
VALUES (2, 2, 3, GETDATE(), 'accepted', GETDATE(), 'close', NULL, NULL);

INSERT INTO Friendships(FriendshipID, UserID1, UserID2, FriendshipDate, Status, LastInteractionDate, FriendshipType, BlockedBy, UnfriendDate)
VALUES (3, 1, 3, GETDATE(), 'accepted', GETDATE(), 'regular', NULL, NULL);

--

INSERT INTO PrivacySettings(UserID, WhoCanViewProfile, WhoCanContactUser, WhoCanSeePosts)
VALUES (1, 'Everyone', 'Everyone', 'Friends');

INSERT INTO PrivacySettings(UserID, WhoCanViewProfile, WhoCanContactUser, WhoCanSeePosts)
VALUES (2, 'Friends', 'Friends', 'Friends');

INSERT INTO PrivacySettings(UserID, WhoCanViewProfile, WhoCanContactUser, WhoCanSeePosts)
VALUES (3, 'Everyone', 'Everyone', 'Everyone');

-----------------------------------------------------------------------------------------------------

--------------------------------------------------  functions, stored procedures, triggers, and views



-- ## FUNCTIONS ##

-- Count of post likes

USE SocialMedia
GO

CREATE FUNCTION CountLikes
(
    @postId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @result INT
    SET @result = (SELECT COUNT(*) FROM Likes WHERE PostID = @postId)
    RETURN @result
END

-- for test

USE SocialMedia
GO

SELECT dbo.CountLikes(1)

-- Get User Profile Picture

USE SocialMedia
GO

CREATE FUNCTION GetUserProfilePicture
(
    @userId INT
)
RETURNS VARBINARY(MAX)
AS
BEGIN
    DECLARE @result VARBINARY(MAX)
    SET @result = (SELECT ProfilePicture FROM Users WHERE UserID = @userId)
    RETURN @result
END

-- for test

USE SocialMedia
GO

SELECT dbo.GetUserProfilePicture(1)

-- 

USE SocialMedia
GO

CREATE FUNCTION GetGroupMembers
(
    @groupId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT u.FirstName, u.LastName
    FROM GroupMembers gm
    INNER JOIN Users u ON u.UserID = gm.UserID
    WHERE gm.GroupID = @groupId
)

-- for test

USE SocialMedia
GO

SELECT * FROM GetGroupMembers(1);



-- ## STORED PROCEDURES ##

-- Adding post

USE SocialMedia
GO

CREATE PROCEDURE AddNewPost
(
    @userId INT,
    @postContent VARCHAR(MAX),
    @postType VARCHAR(20),
    @postDate DATETIME
)
AS
BEGIN
    INSERT INTO Posts (UserID, PostContent, PostType, PostDate)
    VALUES (@userId, @postContent, @postType, @postDate)
END

-- for test

USE SocialMedia
GO

EXEC AddNewPost
    @userId = 1,
    @postContent = 'This is a new post.',
    @postType = 'Text',
    @postDate = '2023-05-12 19:30:00';

USE SocialMedia
GO

SELECT * FROM Posts

--  Update user profile picture

USE SocialMedia
GO

CREATE PROCEDURE UpdateUserProfilePicture
(
    @userId INT,
    @profilePicture VARBINARY(MAX)
)
AS
BEGIN
    UPDATE Users
    SET ProfilePicture = @profilePicture
    WHERE UserID = @userId
END

-- for test

USE SocialMedia
GO

DECLARE @ProfilePicture VARBINARY(MAX);
SET @ProfilePicture = (SELECT BulkColumn FROM OPENROWSET(BULK 'C:\Users\user\Desktop\DBlab\project\phase 2\picture.jpg', SINGLE_BLOB) AS x)

EXEC UpdateUserProfilePicture
    @userId = 1,
    @profilePicture = @ProfilePicture;

-- Add member to grop

USE SocialMedia
GO

CREATE PROCEDURE AddNewGroupMember
(
    @groupId INT,
    @userId INT,
    @joinDate DATETIME,
    @memberRole VARCHAR(50)
)
AS
BEGIN
    INSERT INTO GroupMembers (GroupID, UserID, JoinDate, MemberRole)
    VALUES (@groupId, @userId, @joinDate, @memberRole)
END

-- for test

USE SocialMedia
GO

EXEC AddNewGroupMember
    @groupId = 2,
    @userId = 2,
    @joinDate = '2023-05-12 19:30:00',
    @memberRole = 'Member';




-- ## STORED PROCEDURES ##

-- Update Last Interaction

USE SocialMedia
GO

CREATE TRIGGER UpdateLastInteractionDate
ON Comments
AFTER INSERT
AS
BEGIN
    UPDATE Friendships
    SET LastInteractionDate = GETDATE()
    WHERE UserID1 = (SELECT UserID FROM inserted) OR UserID2 = (SELECT UserID FROM inserted)
END

-- delete like when post will be delete

USE SocialMedia
GO

CREATE TRIGGER DeleteLikesOnPostDelete
ON Posts
AFTER DELETE
AS
BEGIN
    DELETE FROM Likes
    WHERE PostID IN (SELECT PostID FROM deleted)
END

-- Prevent user to join if he havs been blocked

USE SocialMedia
GO

CREATE TRIGGER BlockUserFromJoiningGroup
ON GroupMembers
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @blockedId INT
    SET @blockedId = (SELECT BlockedBy FROM Friendships WHERE UserID2 = (SELECT UserID FROM inserted))
    
    IF EXISTS (SELECT * FROM inserted WHERE UserID = @blockedId)
        RAISERROR ('The user has been blocked from joining this group', 16, 1)
    ELSE
        INSERT INTO GroupMembers (GroupID, UserID, JoinDate, MemberRole)
        SELECT GroupID, UserID, JoinDate, MemberRole FROM inserted
END




-- ## VIEWS ##

-- View for showing the list of posts, thir likes and comments

USE SocialMedia
GO

CREATE VIEW PostDetails AS
SELECT p.PostID, p.PostContent, p.PostType, p.PostDate, u.FirstName, u.LastName,
    COUNT(l.LikeID) AS Likes, 
    (SELECT COUNT(*) FROM Comments WHERE PostID = p.PostID) AS Comments
FROM Posts p
INNER JOIN Users u ON u.UserID = p.UserID
LEFT JOIN Likes l ON l.PostID = p.PostID
GROUP BY p.PostID, p.PostContent, p.PostType, p.PostDate, u.FirstName, u.LastName

-- for test

USE SocialMedia
GO

SELECT * FROM PostDetails

-- Show group owners 

CREATE VIEW GroupOwners AS
SELECT u.FirstName, u.LastName, g.GroupName, g.GroupDescription, g.CreationDate
FROM Groups g
INNER JOIN Users u ON u.UserID = g.GroupOwnerID

-- for test

USE SocialMedia
GO

SELECT * FROM GroupOwners

-- show list of users pprivacy 

USE SocialMedia
GO

CREATE VIEW UserPrivacySettings AS
SELECT u.FirstName, u.LastName, ps.WhoCanViewProfile, ps.WhoCanContactUser, ps.WhoCanSeePosts
FROM Users u
INNER JOIN PrivacySettings ps ON ps.UserID = u.UserID

-- for test

USE SocialMedia
GO

SELECT * FROM  UserPrivacySettings

-----------------------------------------------------------------------------------------------------

------------------------------------------------------------------------  Get backup from Database...

BACKUP DATABASE SocialMedia
TO DISK = 'C:\Users\user\Desktop\DBlab\project\phase 2\backupfile.bak'
WITH FORMAT;

-- but i get full backup graphically from (right click on database name, then select Task and at the end select Backup... :")