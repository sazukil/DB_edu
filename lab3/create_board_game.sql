SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Online board game store
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Online board game store` DEFAULT CHARACTER SET utf8 ;
USE `Online board game store` ;

-- -----------------------------------------------------
-- Table `Online board game store`.`Maker`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Maker` (
  `id_maker` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(100) NOT NULL,
  `Country` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(256) NOT NULL,
  `Phone` VARCHAR(15) NULL,
  PRIMARY KEY (`id_maker`),
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Online board game store`.`Discount`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Discount` (
  `id_discount` INT NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(100) NOT NULL,
  `Discount_amount` TINYINT UNSIGNED NOT NULL,
  `Start_date` DATE NOT NULL,
  `End_date` DATE NOT NULL,
  PRIMARY KEY (`id_discount`),
  UNIQUE INDEX `Title_UNIQUE` (`Title` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Online board game store`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Product` (
  `id_product` INT NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(100) NOT NULL,
  `Description` TEXT NULL,
  `Price` MEDIUMINT UNSIGNED NOT NULL,
  `Difficult` VARCHAR(10) NOT NULL,
  `Age_limit` TINYINT UNSIGNED NOT NULL,
  `Game_time` VARCHAR(10) NOT NULL,
  `Number_of_players` VARCHAR(10) NOT NULL,
  `Maker_id_maker` INT NOT NULL,
  `Discount_id_discount` INT NOT NULL,
  UNIQUE INDEX `Title_UNIQUE` (`Title` ASC) VISIBLE,
  PRIMARY KEY (`id_product`),
  INDEX `fk_Product_Maker_idx` (`Maker_id_maker` ASC) VISIBLE,
  INDEX `fk_Product_Discount_idx` (`Discount_id_discount` ASC) VISIBLE,
  CONSTRAINT `fk_Product_Maker`
    FOREIGN KEY (`Maker_id_maker`)
    REFERENCES `Online board game store`.`Maker` (`id_maker`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_Discount`
    FOREIGN KEY (`Discount_id_discount`)
    REFERENCES `Online board game store`.`Discount` (`id_discount`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Online board game store`.`Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Category` (
  `id_category` INT NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(60) NOT NULL,
  `Description` TINYTEXT NOT NULL,
  `Classifier` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_category`),
  UNIQUE INDEX `Title_UNIQUE` (`Title` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Online board game store`.`Product_to_Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Product_to_Category` (
  `id` INT NOT NULL,
  `Product_id_product` INT NOT NULL,
  `Category_id_category` INT NOT NULL,
  PRIMARY KEY (`id`, `Product_id_product`, `Category_id_category`),
  INDEX `fk_Product_to_Category_Product_idx` (`Product_id_product` ASC) VISIBLE,
  INDEX `fk_Product_to_Category_Category_idx` (`Category_id_category` ASC) VISIBLE,
  CONSTRAINT `fk_Product_to_Category_Product`
    FOREIGN KEY (`Product_id_product`)
    REFERENCES `Online board game store`.`Product` (`id_product`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Product_to_Category_Category`
    FOREIGN KEY (`Category_id_category`)
    REFERENCES `Online board game store`.`Category` (`id_category`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Online board game store`.`Buyer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Buyer` (
  `Login` VARCHAR(60) NOT NULL,
  `Password` VARCHAR(60) NOT NULL,
  `Lastname` VARCHAR(60) NOT NULL,
  `Firstname` VARCHAR(60) NOT NULL,
  `Patronymic` VARCHAR(60) NULL,
  `Birthday` DATE NOT NULL,
  `Registration_date` DATE NOT NULL,
  `Email` VARCHAR(256) NULL,
  `Phone` VARCHAR(15) NULL,
  PRIMARY KEY (`Login`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Online board game store`.`Feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Feedback` (
  `id_feedback` INT NOT NULL AUTO_INCREMENT,
  `Text` TEXT NOT NULL,
  `Score` TINYINT UNSIGNED NOT NULL,
  `Date_of_feedback` DATE NOT NULL,
  `Product_id_product` INT NOT NULL,
  `Buyer_Login` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_feedback`),
  INDEX `fk_Feedback_Product_idx` (`Product_id_product` ASC) VISIBLE,
  INDEX `fk_Feedback_Buyer_idx` (`Buyer_Login` ASC) VISIBLE,
  CONSTRAINT `fk_Feedback_Product`
    FOREIGN KEY (`Product_id_product`)
    REFERENCES `Online board game store`.`Product` (`id_product`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Feedback_Buyer`
    FOREIGN KEY (`Buyer_Login`)
    REFERENCES `Online board game store`.`Buyer` (`Login`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Online board game store`.`Favorites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Favorites` (
  `id_favorites` INT NOT NULL AUTO_INCREMENT,
  `Count_products` TINYINT UNSIGNED NOT NULL,
  `Update_date` DATE NOT NULL,
  `Buyer_Login` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_favorites`),
  INDEX `fk_Favorites_Buyer_idx` (`Buyer_Login` ASC) VISIBLE,
  CONSTRAINT `fk_Favorites_Buyer`
    FOREIGN KEY (`Buyer_Login`)
    REFERENCES `Online board game store`.`Buyer` (`Login`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Online board game store`.`Product_to_Favorites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Product_to_Favorites` (
  `Date_added` DATE NOT NULL,
  `Product_id_product` INT NOT NULL,
  `Favorites_id_favorites` INT NOT NULL,
  PRIMARY KEY (`Product_id_product`, `Favorites_id_favorites`),
  INDEX `fk_Product_to_Favorites_Favorites_idx` (`Favorites_id_favorites` ASC) VISIBLE,
  CONSTRAINT `fk_Product_to_Favorites_Product`
    FOREIGN KEY (`Product_id_product`)
    REFERENCES `Online board game store`.`Product` (`id_product`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Product_to_Favorites_Favorites`
    FOREIGN KEY (`Favorites_id_favorites`)
    REFERENCES `Online board game store`.`Favorites` (`id_favorites`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Online board game store`.`Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Order` (
  `Order_numder` INT UNSIGNED NOT NULL,
  `Delivery_method` VARCHAR(15) NOT NULL,
  `Status` VARCHAR(15) NOT NULL,
  `Adress` VARCHAR(150) NOT NULL,
  `Order_date` DATE NOT NULL,
  PRIMARY KEY (`Order_numder`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Online board game store`.`Order_to_Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Order_to_Product` (
  `Count` TINYINT UNSIGNED NOT NULL,
  `Product_id_product` INT NOT NULL,
  `Order_Order numder` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Product_id_product`, `Order_Order numder`),
  INDEX `fk_Order_to_Product_Order_idx` (`Order_Order numder` ASC) VISIBLE,
  CONSTRAINT `fk_Order_to_Product_Product`
    FOREIGN KEY (`Product_id_product`)
    REFERENCES `Online board game store`.`Product` (`id_product`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Order_to_Product_Order`
    FOREIGN KEY (`Order_Order numder`)
    REFERENCES `Online board game store`.`Order` (`Order_numder`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Online board game store`.`Payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Payment` (
  `id_payment` INT NOT NULL AUTO_INCREMENT,
  `Status` VARCHAR(20) NOT NULL,
  `Payment_method` VARCHAR(15) NOT NULL,
  `Payment_date` DATE NOT NULL,
  `Cost` MEDIUMINT UNSIGNED NOT NULL,
  `Order_Order numder` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_payment`),
  INDEX `fk_Payment_Order_idx` (`Order_Order numder` ASC) VISIBLE,
  CONSTRAINT `fk_Payment_Order`
    FOREIGN KEY (`Order_Order numder`)
    REFERENCES `Online board game store`.`Order` (`Order_numder`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Online board game store`.`Refund`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Online board game store`.`Refund` (
  `id_refund` INT NOT NULL AUTO_INCREMENT,
  `Reason` VARCHAR(100) NOT NULL,
  `Status` VARCHAR(15) NOT NULL,
  `Refund_date` DATE NOT NULL,
  `Order_Order_numder` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_refund`),
  INDEX `fk_Refund_Order_idx` (`Order_Order_numder` ASC) VISIBLE,
  CONSTRAINT `fk_Refund_Order`
    FOREIGN KEY (`Order_Order_numder`)
    REFERENCES `Online board game store`.`Order` (`Order_numder`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
