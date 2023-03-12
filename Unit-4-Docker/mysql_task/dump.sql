CREATE DATABASE IF NOT EXISTS `mydb`;

-- Table structure for table `SuperHeroes`
USE `mydb`
CREATE TABLE IF NOT EXISTS `SuperHeroes` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `status` tinyint(10) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=10001 ;

-- Populating data for table `SuperHeroes`
INSERT INTO `SuperHeroes` (`user_id`, `username`, `first_name`, `last_name`, `gender`, `password`, `status`) VALUES
(1, 'Superman', 'CLark', 'Kent', 'Male', 'e6a33eee180b07e563d74fee8c2c66b8', 1),
(2, 'Batman', 'Bruce', 'Wayne', 'Male', '2e7dc6b8a1598f4f75c3eaa47958ee2f', 1),
(3, 'Spiderman', 'Peter', 'Parker', 'Male', '1c3a8e03f448d211904161a6f5849b68', 1),
(4, 'Hulk', 'David', 'Bruce Banner', 'Male', '62f0a68a4179c5cdd997189760cbcf18', 1),
(5, 'Captain America', 'Steve', 'Rogers', 'Male', '61bd060b07bddfecccea56a82b850ecf', 1),
(6, 'Green Hornet', 'Britt', 'Reid', 'Male', '7055b3d9f5cb2829c26cd7e0e601cde5', 1),
(7, 'Green Lantern', 'Hal', 'Jordan', 'Male', 'b7f72d6eb92b45458020748c8d1a3573', 1),
(8, 'Wolverine', 'James', 'Howlett', 'Male', '299cbf7171ad1b2967408ed200b4e26c', 1),
(9, 'Mr.Fantastic', 'Reed', 'Richards', 'Male', 'aa736a35dc15934d67c0a999dccff8f6', 1),
(10, 'Flash', 'Barry', 'Allen', 'Male', 'a28dca31f5aa5792e1cefd1dfd098569', 1),
(11, 'Cyclops', 'Scott', 'Summers', 'Male', 'a28dca31f5aa5792e1cefd1dfd098569', 1),
(12, 'Phantom', 'Kit', 'Walker Jr.', 'Male', 'a28dca31f5aa5792e1cefd1dfd098569', 1),
(13, 'Catwoman', 'Selina', 'Kyle0', 'Female', 'a28dca31f5aa5792e1cefd1dfd098569', 1),
(14, 'Wonder Woman', 'Yeoman', 'Diana Prince', 'Female','a28dca31f5aa5792e1cefd1dfd098569', 1),
(15, 'Batgirl', 'Barbara', 'Gordon', 'Female', 'a28dca31f5aa5792e1cefd1dfd098569', 1),
(16, 'StormXX', 'Ororo', 'Monroe', 'Female', 'a28dca31f5aa5792e1cefd1dfd098569', 1),
(17, 'Black Widow', 'Natasha', 'Romanova', 'Female', 'a28dca31f5aa5792e1cefd1dfd098569', 1),
(18, 'Phoenix', 'Jean', 'Grey', 'Female', 'a28dca31f5aa5792e1cefd1dfd098569', 1);

