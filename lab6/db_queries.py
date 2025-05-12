import pymysql.cursors
from datetime import datetime
import random

class DatabaseManager:
    def __init__(self, config):
        self.config = config


    def get_connection(self):
        return pymysql.connect(**self.config)


    def get_all_products(self):
        sql = """
        SELECT p.*, m.Name as maker_name,
               GROUP_CONCAT(c.Title SEPARATOR ', ') as categories
        FROM Product p
        JOIN Maker m ON p.Maker_id_maker = m.id_maker
        LEFT JOIN Product_to_Category ptc ON p.id_product = ptc.Product_id_product
        LEFT JOIN Category c ON ptc.Category_id_category = c.id_category
        GROUP BY p.id_product
        LIMIT 100;
        """
        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql)
                return cursor.fetchall()


    def get_filtered_products(self, title=None, min_price=None, max_price=None,
                    difficulty=None, min_age=None, max_age=None,
                    game_time=None, players=None, maker_id=None, categories=None,
                    min_discount=0, max_discount=100):
        sql = """
        SELECT p.*, m.Name as maker_name, d.Discount_amount as discount,
            d.Title, GROUP_CONCAT(c.Title SEPARATOR ', ') as categories
        FROM Product p
        JOIN Maker m ON p.Maker_id_maker = m.id_maker
        LEFT JOIN Discount d ON p.Discount_id_discount = d.id_discount
        LEFT JOIN Product_to_Category ptc ON p.id_product = ptc.Product_id_product
        LEFT JOIN Category c ON ptc.Category_id_category = c.id_category
        WHERE 1=1
        """

        params = []

        if title:
            sql += " AND p.Title LIKE %s"
            params.append(f"%{title}%")
        if min_price is not None:
            sql += " AND p.Price >= %s"
            params.append(min_price)
        if max_price is not None:
            sql += " AND p.Price <= %s"
            params.append(max_price)
        if difficulty:
            sql += " AND p.Difficult = %s"
            params.append(difficulty)
        if min_age is not None:
            sql += " AND p.Age_limit >= %s"
            params.append(min_age)
        if max_age is not None:
            sql += " AND p.Age_limit <= %s"
            params.append(max_age)
        if game_time:
            sql += " AND p.Game_time LIKE %s"
            params.append(f"%{game_time}%")
        if players:
            sql += " AND p.Number_of_players LIKE %s"
            params.append(f"%{players}%")
        if maker_id:
            sql += " AND p.Maker_id_maker = %s"
            params.append(maker_id)
        if categories:
            sql += " AND ptc.Category_id_category IN ({})".format(
                ','.join(['%s'] * len(categories)))
            params.extend([int(c) for c in categories])
        if min_discount is not None:
            sql += " AND d.Discount_amount >= %s"
            params.append(float(min_discount))
        if max_discount is not None:
            sql += " AND d.Discount_amount <= %s"
            params.append(float(max_discount))

        sql += " GROUP BY p.id_product;"

        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql, params)
                return cursor.fetchall()


    def create_product(self, data):
        try:
            connection = self.get_connection()
            cursor = connection.cursor()

            sql = """
                INSERT INTO Product (
                    Title, Description, Price, Difficult,
                    Age_limit, Game_time, Number_of_players, Maker_id_maker, Discount_id_discount
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                """
            cursor.execute(sql, (
                data['title'],
                data['description'],
                float(data['price']),
                data['difficult'],
                int(data['age_limit']),
                data['game_time'],
                data['number_of_players'],
                int(data['maker_id']),
                data['Discount_id_discount']
            ))
            product_id = cursor.lastrowid

            for category_id in data['category_ids']:
                sql = """
                    INSERT INTO Product_to_Category
                    (Product_id_product, Category_id_category)
                    VALUES (%s, %s)
                    """
                cursor.execute(sql, (product_id, int(category_id)))

            connection.commit()
            return True

        except Exception as e:
            print(f"Ошибка: {e}")
            if 'connection' in locals():
                connection.rollback()
            return False
        finally:
            if 'cursor' in locals():
                cursor.close()
            if 'connection' in locals():
                connection.close()


    def get_product_by_id(self, product_id):
        connection = None
        cursor = None
        try:
            connection = self.get_connection()
            cursor = connection.cursor()
            sql = "SELECT * FROM Product WHERE id_product = %s"
            cursor.execute(sql, (int(product_id),))
            return cursor.fetchone()
        except Exception as e:
            print(f"Ошибка при получении товара: {str(e)}")
            return None
        finally:
            if cursor:
                cursor.close()
            if connection:
                connection.close()


    def get_product_categories_ids(self, product_id):
        connection = None
        cursor = None
        try:
            connection = self.get_connection()
            cursor = connection.cursor()
            sql = "SELECT Category_id_category FROM Product_to_Category WHERE Product_id_product = %s"
            cursor.execute(sql, (int(product_id),))
            return [row['Category_id_category'] for row in cursor.fetchall()]
        except Exception as e:
            print(f"Ошибка при получении категорий товара: {str(e)}")
            return []
        finally:
            if cursor:
                cursor.close()
            if connection:
                connection.close()


    def update_product(self, data):
        connection = None
        cursor = None
        try:
            connection = self.get_connection()
            cursor = connection.cursor()

            sql = """
            UPDATE Product SET
                Title = %s,
                Description = %s,
                Price = %s,
                Difficult = %s,
                Age_limit = %s,
                Game_time = %s,
                Number_of_players = %s,
                Maker_id_maker = %s,
                Discount_id_discount = %s
            WHERE id_product = %s
            """
            cursor.execute(sql, (
                data['title'],
                data['description'],
                float(data['price']),
                data['difficult'],
                int(data['age_limit']),
                data['game_time'],
                data['number_of_players'],
                int(data['maker_id']),
                data['Discount_id_discount'],
                int(data['id'])
            ))

            cursor.execute(
                "DELETE FROM Product_to_Category WHERE Product_id_product = %s",
                (int(data['id']),)
            )

            for category_id in data['category_ids']:
                cursor.execute(
                    "INSERT INTO Product_to_Category (Product_id_product, Category_id_category) VALUES (%s, %s)",
                    (int(data['id']), int(category_id))
                )

            connection.commit()
            return True

        except Exception as e:
            print(f"Ошибка при обновлении товара: {str(e)}")
            if connection:
                connection.rollback()
            return False
        finally:
            if cursor:
                cursor.close()
            if connection:
                connection.close()


    def delete_product(self, product_id):
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    cursor.execute("DELETE FROM Product_to_Category WHERE Product_id_product = %s", (product_id,))
                    cursor.execute("DELETE FROM Product WHERE id_product = %s", (product_id,))
                connection.commit()
                return True
        except Exception as e:
            print(f"Ошибка: {e}")
            if 'connection' in locals():
                connection.rollback()
            return False


    def get_all_categories(self):
        sql = "SELECT * FROM Category"
        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql)
                return cursor.fetchall()


    def get_all_makers(self):
        sql = "SELECT * FROM Maker"
        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql)
                return cursor.fetchall()

    def get_filtered_makers(self, name=None, country=None, email=None, phone=None,
                       sort_by='name', sort_order='asc'):
        sql = """
        SELECT * FROM Maker
        WHERE 1=1
        """

        params = []

        if name:
            sql += " AND Name LIKE %s"
            params.append(f"%{name}%")
        if country:
            sql += " AND Country = %s"
            params.append(country)
        if email:
            sql += " AND Email LIKE %s"
            params.append(f"%{email}%")
        if phone:
            sql += " AND Phone LIKE %s"
            params.append(f"%{phone}%")

        valid_sort_columns = ['name', 'country']
        sort_by = sort_by if sort_by in valid_sort_columns else 'name'
        sort_order = 'DESC' if sort_order.lower() == 'desc' else 'ASC'

        sql += f" ORDER BY {sort_by} {sort_order}"

        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql, params)
                return cursor.fetchall()


    def get_unique_countries(self):
        sql = "SELECT DISTINCT Country FROM Maker ORDER BY Country"
        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql)
                return [row['Country'] for row in cursor.fetchall()]


    def create_maker(self, data):
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    sql = """
                    INSERT INTO Maker (Name, Country, Email, Phone)
                    VALUES (%s, %s, %s, %s)
                    """
                    cursor.execute(sql, (
                        data['name'],
                        data['country'],
                        data['email'],
                        data['phone']
                    ))
                connection.commit()
                return True
        except Exception as e:
            print(f"Ошибка при создании производителя: {str(e)}")
            return False


    def get_maker_by_id(self, maker_id):
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    sql = "SELECT * FROM Maker WHERE id_maker = %s"
                    cursor.execute(sql, (maker_id,))
                    return cursor.fetchone()
        except Exception as e:
            print(f"Ошибка при получении производителя: {str(e)}")
            return None


    def update_maker(self, data):
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    sql = """
                    UPDATE Maker SET
                        Name = %s,
                        Country = %s,
                        Email = %s,
                        Phone = %s
                    WHERE id_maker = %s
                    """
                    cursor.execute(sql, (
                        data['name'],
                        data['country'],
                        data['email'],
                        data['phone'],
                        data['id']
                    ))
                connection.commit()
                return True
        except Exception as e:
            print(f"Ошибка при обновлении производителя: {str(e)}")
            return False

    def delete_maker(self, maker_id):
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    cursor.execute("SELECT COUNT(*) FROM Product WHERE Maker_id_maker = %s", (maker_id,))
                    product_count = cursor.fetchone()['COUNT(*)']

                    if product_count > 0:
                        return False

                    cursor.execute("DELETE FROM Maker WHERE id_maker = %s", (maker_id,))
                connection.commit()
                return True
        except Exception as e:
            print(f"Ошибка при удалении производителя: {str(e)}")
            return False


    def get_products_by_name_substring(self, substring):
        sql = """
        SELECT
            p.id_product,
            p.Title as product_title,
            GROUP_CONCAT(DISTINCT c.Title SEPARATOR '\n') as categories,
            m.Name as maker_name,
            p.Price,
            p.Age_limit
        FROM Product p
        LEFT JOIN Product_to_Category ptc ON p.id_product = ptc.Product_id_product
        LEFT JOIN Category c ON ptc.Category_id_category = c.id_category
        LEFT JOIN Maker m ON p.Maker_id_maker = m.id_maker
        WHERE p.Title LIKE %s
        GROUP BY p.id_product
        ORDER BY p.Title
        """

        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql, (f"%{substring}%",))
                return cursor.fetchall()


    def get_product_categories(self, product_name):
        result = {}
        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                sql = "SELECT * FROM Product WHERE Title = %s LIMIT 1"
                cursor.execute(sql, (product_name,))
                result['product'] = cursor.fetchone()

                sql = """
                SELECT c.Title
                FROM Category c
                JOIN Product_to_Category ptc ON c.id_category = ptc.Category_id_category
                JOIN Product p ON ptc.Product_id_product = p.id_product
                WHERE p.Title = %s
                """
                cursor.execute(sql, (product_name,))
                result['categories'] = cursor.fetchall()

        return result

    def get_user_orders(self, login):
        sql = """
        SELECT
            o.Order_numder AS Order_numder,
            o.Order_date AS order_date,
            o.Delivery_method AS delivery_method,
            o.Status AS order_status,
            (
                SELECT GROUP_CONCAT(
                    CONCAT(p.Title, ' - ', otp.Count, ' шт. (', p.Price, ' ₽/шт.)')
                    SEPARATOR '; '
                )
                FROM Order_to_Product otp
                JOIN Product p ON otp.Product_id_product = p.id_product
                WHERE otp.Order_Order_numder = o.Order_numder
            ) AS products,
            pm.Cost AS total_cost,
            pm.Payment_method AS payment_method,
            pm.Status AS payment_status
        FROM `Order` o
        LEFT JOIN Payment pm ON o.Order_numder = pm.Order_Order_numder
        WHERE o.Buyer_Login = %s
        ORDER BY o.Order_date ASC;
        """

        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql, (login,))
                return cursor.fetchall()

    def get_all_product_category_relations(self):
        """Получить все связи продукты-категории"""
        sql = """
        SELECT ptc.id, ptc.Product_id_product, p.Title as product_title,
            ptc.Category_id_category, c.Title as category_title
        FROM Product_to_Category ptc
        JOIN Product p ON ptc.Product_id_product = p.id_product
        JOIN Category c ON ptc.Category_id_category = c.id_category
        ORDER BY ptc.id
        """
        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql)
                return cursor.fetchall()

    def create_product_category_relation(self, product_id, category_id):
        """Создать новую связь продукт-категория"""
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    cursor.execute("SELECT MAX(id) FROM Product_to_Category")
                    max_id = cursor.fetchone()['MAX(id)'] or 0
                    new_id = max_id + 1

                    sql = """
                    INSERT INTO Product_to_Category (id, Product_id_product, Category_id_category)
                    VALUES (%s, %s, %s)
                    """
                    cursor.execute(sql, (new_id, product_id, category_id))
                connection.commit()
                return True
        except Exception as e:
            print(f"Ошибка при создании связи: {str(e)}")
            return False

    def update_product_category_relation(self, relation_id, new_product_id, new_category_id):
        """Обновить связь продукт-категория"""
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    sql = """
                    UPDATE Product_to_Category
                    SET Product_id_product = %s,
                        Category_id_category = %s
                    WHERE id = %s
                    """
                    cursor.execute(sql, (new_product_id, new_category_id, relation_id))
                connection.commit()
                return True
        except Exception as e:
            print(f"Ошибка при обновлении связи: {str(e)}")
            return False

    def get_product_category_relation(self, relation_id):
        """Получить связь продукт-категория по ID"""
        sql = """
        SELECT ptc.id, ptc.Product_id_product, p.Title as product_title,
            ptc.Category_id_category, c.Title as category_title
        FROM Product_to_Category ptc
        JOIN Product p ON ptc.Product_id_product = p.id_product
        JOIN Category c ON ptc.Category_id_category = c.id_category
        WHERE ptc.id = %s
        """
        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql, (relation_id,))
                return cursor.fetchone()

    def delete_product_category_relation(self, relation_id):
        """Удалить связь продукт-категория"""
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    sql = "DELETE FROM Product_to_Category WHERE id = %s"
                    cursor.execute(sql, (relation_id,))
                connection.commit()
                return True
        except Exception as e:
            print(f"Ошибка при удалении связи: {str(e)}")
            return False

    def get_products_with_categories(self):
        """Получить продукты с их категориями (группировка по продукту)"""
        sql = """
        SELECT
            p.id_product,
            p.Title as product_title,
            GROUP_CONCAT(c.Title SEPARATOR ', ') as categories,
            GROUP_CONCAT(c.id_category SEPARATOR ',') as category_ids
        FROM Product p
        LEFT JOIN Product_to_Category ptc ON p.id_product = ptc.Product_id_product
        LEFT JOIN Category c ON ptc.Category_id_category = c.id_category
        GROUP BY p.id_product
        ORDER BY p.Title
        """
        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql)
                return cursor.fetchall()

    def update_product_categories(self, product_id, category_ids):
        """Обновить все категории продукта"""
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    cursor.execute(
                        "DELETE FROM Product_to_Category WHERE Product_id_product = %s",
                        (product_id,)
                    )

                    for category_id in category_ids:
                        cursor.execute("SELECT MAX(id) FROM Product_to_Category")
                        max_id = cursor.fetchone()['MAX(id)'] or 0
                        new_id = max_id + 1

                        cursor.execute(
                            "INSERT INTO Product_to_Category (id, Product_id_product, Category_id_category) VALUES (%s, %s, %s)",
                            (new_id, product_id, int(category_id))
                        )

                connection.commit()
                return True
        except Exception as e:
            print(f"Ошибка при обновлении категорий товара: {str(e)}")
            return False

    def get_filtered_products_with_categories(self, product_name=None, category_ids=None):
        sql = """
        SELECT
            p.id_product,
            p.Title as product_title,
            GROUP_CONCAT(c.Title SEPARATOR ', ') as categories,
            GROUP_CONCAT(c.id_category SEPARATOR ',') as category_ids
        FROM Product p
        LEFT JOIN Product_to_Category ptc ON p.id_product = ptc.Product_id_product
        LEFT JOIN Category c ON ptc.Category_id_category = c.id_category
        WHERE 1=1
        """

        params = []

        if product_name:
            sql += " AND p.Title LIKE %s"
            params.append(f"%{product_name}%")

        if category_ids:
            placeholders = ','.join(['%s'] * len(category_ids))
            sql += f" AND c.id_category IN ({placeholders})"
            params.extend([int(cid) for cid in category_ids])

        sql += " GROUP BY p.id_product ORDER BY p.Title"

        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql, params)
                return cursor.fetchall()


    def authenticate_user(self, login, password):
        sql = """
        SELECT Login, Lastname, Firstname
        FROM Buyer
        WHERE Login = %s AND Password = %s
        """
        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql, (login, password))
                return cursor.fetchone()

    def create_user(self, login, password, lastname, firstname, patronymic=None, birthday=None, email=None, phone=None):
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    sql = """
                    INSERT INTO Buyer (Login, Password, Lastname, Firstname, Patronymic, Birthday, Email, Phone, Registration_date)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, CURDATE())
                    """
                    cursor.execute(sql, (
                        login,
                        password,
                        lastname,
                        firstname,
                        patronymic,
                        birthday,
                        email,
                        phone
                    ))
                connection.commit()
                return True
        except pymysql.err.IntegrityError:
            return False
        except Exception as e:
            print(f"Ошибка при создании пользователя: {str(e)}")
            return False

    def get_user_favorites(self, user_login):
        sql = """
        SELECT p.*, ptf.Date_added
        FROM Product p
        JOIN Product_to_Favorites ptf ON p.id_product = ptf.Product_id_product
        JOIN Favorites f ON ptf.Favorites_id_favorites = f.id_favorites
        WHERE f.Buyer_Login = %s
        ORDER BY ptf.Date_added DESC
        """
        with self.get_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute(sql, (user_login,))
                return cursor.fetchall()

    def add_to_favorites(self, user_login, product_id):
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    cursor.execute("SELECT id_favorites FROM Favorites WHERE Buyer_Login = %s", (user_login,))
                    favorites = cursor.fetchone()

                    if not favorites:
                        cursor.execute(
                            "INSERT INTO Favorites (Count_products, Update_date, Buyer_Login) VALUES (0, CURDATE(), %s)",
                            (user_login,)
                        )
                        favorites_id = cursor.lastrowid
                    else:
                        favorites_id = favorites['id_favorites']

                    cursor.execute(
                        "SELECT * FROM Product_to_Favorites WHERE Product_id_product = %s AND Favorites_id_favorites = %s",
                        (product_id, favorites_id)
                    )
                    if cursor.fetchone():
                        return False

                    cursor.execute(
                        "INSERT INTO Product_to_Favorites (Date_added, Product_id_product, Favorites_id_favorites) "
                        "VALUES (CURDATE(), %s, %s)",
                        (product_id, favorites_id)
                    )

                    cursor.execute(
                        "UPDATE Favorites SET Count_products = Count_products + 1, Update_date = CURDATE() "
                        "WHERE id_favorites = %s",
                        (favorites_id,)
                    )

                connection.commit()
                return True
        except Exception as e:
            print(f"Ошибка при добавлении в избранное: {str(e)}")
            return False

    def delete_from_favorites(self, user_login, product_id):
        """Удаляет товар из избранного пользователя"""
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    cursor.execute(
                        "SELECT id_favorites FROM Favorites WHERE Buyer_Login = %s",
                        (user_login,)
                    )
                    favorites = cursor.fetchone()

                    if not favorites:
                        return False

                    favorites_id = favorites['id_favorites']

                    cursor.execute(
                        "DELETE FROM Product_to_Favorites "
                        "WHERE Product_id_product = %s AND Favorites_id_favorites = %s",
                        (product_id, favorites_id))

                    cursor.execute(
                        "UPDATE Favorites "
                        "SET Count_products = GREATEST(0, Count_products - 1), "
                        "Update_date = CURDATE() "
                        "WHERE id_favorites = %s",
                        (favorites_id,))

                connection.commit()
                return True
        except Exception as e:
            print(f"Ошибка при удалении из избранного: {str(e)}")
            return False

    def create_order(self, order_data):
        try:
            with self.get_connection() as connection:
                with connection.cursor() as cursor:
                    order_number = int(datetime.now().strftime("%Y%m%d")[2:] + str(random.randint(100, 999)))

                    order_sql = """
                    INSERT INTO `Order` (Order_numder, Delivery_method, Status, Adress, Order_date, Buyer_Login)
                    VALUES (%s, %s, 'В обработке', %s, CURDATE(), %s)
                    """
                    cursor.execute(order_sql, (
                        order_number,
                        order_data['delivery_method'],
                        order_data['address'],
                        order_data['buyer_login']
                    ))

                    total_cost = 0
                    for product_id, quantity in order_data['cart_items'].items():
                        cursor.execute("SELECT Price FROM Product WHERE id_product = %s", (int(product_id),))
                        product = cursor.fetchone()
                        if product:
                            price = product['Price']
                            total_cost += price * quantity

                            order_product_sql = """
                            INSERT INTO Order_to_Product (Count, Product_id_product, Order_Order_numder)
                            VALUES (%s, %s, %s)
                            """
                            cursor.execute(order_product_sql, (quantity, int(product_id), order_number))

                    payment_sql = """
                    INSERT INTO Payment (Status, Payment_method, Payment_date, Cost, Order_Order_numder)
                    VALUES ('Ожидает оплаты', %s, CURDATE(), %s, %s)
                    """
                    cursor.execute(payment_sql, (order_data['payment_method'], total_cost, order_number))

                    connection.commit()
                    return {'order_number': order_number, 'total_cost': total_cost}
        except Exception as e:
            print(f"Ошибка при создании заказа: {str(e)}")
            if 'connection' in locals():
                connection.rollback()
            return False
