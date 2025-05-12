from flask import Flask, render_template, request, redirect, url_for, flash, session
from db_queries import DatabaseManager
import pymysql
from functools import wraps
from datetime import datetime

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user' not in session:
            flash('Для доступа к этой странице необходимо авторизоваться', 'warning')
            return redirect(url_for('login', next=request.url))
        return f(*args, **kwargs)
    return decorated_function

app = Flask(__name__)
app.secret_key = '00000000'

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'admin',
    'database': 'online board game store',
    'cursorclass': pymysql.cursors.DictCursor
}

db = DatabaseManager(db_config)

@app.route('/')
def index():
    return render_template('index.html')

# Маршруты для товаров
@app.route('/products')
@login_required
def product_list():
    page = request.args.get('page', 1, type=int)
    per_page = 25

    # Создаем копию request.args и удаляем параметр page
    filters = request.args.copy()
    if 'page' in filters:
        filters.pop('page')

    filters = {
        'title': request.args.get('title'),
        'min_price': request.args.get('min_price', type=float),
        'max_price': request.args.get('max_price', type=float),
        'difficulty': request.args.get('difficulty'),
        'min_age': request.args.get('min_age', type=int),
        'max_age': request.args.get('max_age', type=int),
        'game_time': request.args.get('game_time'),
        'players': request.args.get('players'),
        'maker_id': request.args.get('maker_id'),
        'categories': request.args.getlist('categories'),
        'min_discount': request.args.get('min_discount', type=float),
        'max_discount': request.args.get('max_discount', type=float)
    }

    all_products = db.get_filtered_products(**filters)
    total_products = len(all_products)
    total_pages = (total_products + per_page - 1) // per_page
    start = (page - 1) * per_page
    end = start + per_page
    products = all_products[start:end]

    all_makers = db.get_all_makers()
    all_categories = db.get_all_categories()

    return render_template('products/list.html',
                         products=products,
                         all_makers=all_makers,
                         all_categories=all_categories,
                         current_filters=filters,
                         page=page,
                         per_page=per_page,
                         total_products=total_products,
                         total_pages=total_pages)

@app.route('/products/create', methods=['GET', 'POST'])
@login_required
def product_create():
    if request.method == 'POST':
        data = {
            'title': request.form['title'],
            'description': request.form['description'],
            'price': request.form['price'],
            'difficult': request.form['difficult'],
            'age_limit': request.form['age_limit'],
            'game_time': request.form['game_time'],
            'number_of_players': request.form['players'],
            'maker_id': request.form['maker_id'],
            'category_ids': request.form.getlist('categories'),
            'Discount_id_discount': 1
        }
        if db.create_product(data):
            flash('Товар успешно создан', 'success')
            return redirect(url_for('product_list'))
        else:
            flash('Ошибка при создании товара', 'danger')

    makers = db.get_all_makers()
    categories = db.get_all_categories()
    return render_template('products/create.html', makers=makers, categories=categories)

@app.route('/products/edit/<int:product_id>', methods=['GET', 'POST'])
@login_required
def product_edit(product_id):
    if session.get('user', {}).get('login') != 'sazukil':
        flash('У вас нет прав для редактирования товаров', 'danger')
        return redirect(url_for('product_list'))

    if request.method == 'POST':
        try:
            data = {
                'id': product_id,
                'title': request.form['title'],
                'description': request.form['description'],
                'price': request.form['price'],
                'difficult': request.form['difficult'],
                'age_limit': request.form['age_limit'],
                'game_time': request.form['game_time'],
                'number_of_players': request.form['players'],
                'maker_id': request.form['maker_id'],
                'Discount_id_discount': 1,
                'category_ids': request.form.getlist('categories')
            }

            print("Form data:", data)

            if db.update_product(data):
                flash('Товар успешно обновлен', 'success')
                return redirect(url_for('product_list'))
            else:
                flash('Ошибка при обновлении товара', 'danger')
        except Exception as e:
            flash(f'Ошибка сервера: {str(e)}', 'danger')

    try:
        product = db.get_product_by_id(product_id)
        if not product:
            flash('Товар не найден', 'danger')
            return redirect(url_for('product_list'))

        makers = db.get_all_makers()
        categories = db.get_all_categories()
        product_categories = db.get_product_categories_ids(product_id)

        return render_template('products/edit.html',
                            product=product,
                            makers=makers,
                            categories=categories,
                            product_categories=product_categories)
    except Exception as e:
        flash(f'Ошибка при загрузке данных: {str(e)}', 'danger')
        return redirect(url_for('product_list'))


@app.route('/products/delete/<int:product_id>', methods=['POST'])
@login_required
def product_delete(product_id):
    if session.get('user', {}).get('login') != 'sazukil':
        flash('У вас нет прав для удаления товаров', 'danger')
        return redirect(url_for('product_list'))

    if db.delete_product(product_id):
        flash('Товар успешно удален', 'success')
    else:
        flash('Ошибка при удалении товара', 'danger')
    return redirect(url_for('product_list'))

# Маршруты для производителей
@app.route('/makers')
@login_required
def maker_list():
    filters = {
        'name': request.args.get('name'),
        'country': request.args.get('country'),
        'email': request.args.get('email'),
        'phone': request.args.get('phone'),
        'sort_by': request.args.get('sort_by', 'name'),
        'sort_order': request.args.get('sort_order', 'asc')
    }

    makers = db.get_filtered_makers(**filters)

    countries = db.get_unique_countries()

    return render_template('makers/list.html',
                         makers=makers,
                         countries=countries,
                         current_filters=request.args)

@app.route('/makers/create', methods=['GET', 'POST'])
@login_required
def maker_create():
    if request.method == 'POST':
        data = {
            'name': request.form['name'],
            'country': request.form['country'],
            'email': request.form.get('email'),
            'phone': request.form.get('phone')
        }
        if db.create_maker(data):
            flash('Производитель успешно создан', 'success')
            return redirect(url_for('maker_list'))
        else:
            flash('Ошибка при создании производителя', 'danger')
    return render_template('makers/create.html')

@app.route('/makers/edit/<int:maker_id>', methods=['GET', 'POST'])
@login_required
def maker_edit(maker_id):
    if request.method == 'POST':
        data = {
            'id': maker_id,
            'name': request.form['name'],
            'country': request.form['country'],
            'email': request.form.get('email'),
            'phone': request.form.get('phone')
        }
        if db.update_maker(data):
            flash('Производитель успешно обновлен', 'success')
            return redirect(url_for('maker_list'))
        else:
            flash('Ошибка при обновлении производителя', 'danger')

    maker = db.get_maker_by_id(maker_id)
    if not maker:
        flash('Производитель не найден', 'danger')
        return redirect(url_for('maker_list'))
    return render_template('makers/edit.html', maker=maker)

@app.route('/makers/delete/<int:maker_id>', methods=['POST'])
@login_required
def maker_delete(maker_id):
    if db.delete_maker(maker_id):
        flash('Производитель успешно удален', 'success')
    else:
        flash('Ошибка при удалении производителя', 'danger')
    return redirect(url_for('maker_list'))

# Маршрут для категорий
@app.route('/categories')
@login_required
def category_list():
    categories = db.get_all_categories()
    return render_template('categories/list.html', categories=categories)

# Аналитические запросы
@app.route('/analytics/product_categories')
@login_required
def product_categories():
    product_name = request.args.get('product_name', '').strip()

    if product_name:
        products = db.get_products_by_name_substring(product_name)
        return render_template('analytics/product_categories.html',
                            product_name=product_name,
                            products=products)

    return render_template('analytics/product_categories.html')

@app.route('/analytics/user_orders')
@login_required
def user_orders():
    login = request.args.get('login')
    if login:
        orders = db.get_user_orders(login)
        return render_template('analytics/user_orders.html',
                            login=login,
                            orders=orders)
    return render_template('analytics/user_orders.html')

@app.route('/analytics/my_orders')
@login_required
def user_my_orders():
    login = session['user']['login']
    orders = db.get_user_orders(login)
    return render_template('analytics/user_orders.html',
                            login=login,
                            orders=orders)

# Маршруты для товар-категория
@app.route('/product-categories')
@login_required
def product_category_list():
    """Список товаров с их категориями с фильтрацией"""
    product_name = request.args.get('product_name')
    selected_categories = request.args.getlist('categories')

    products = db.get_filtered_products_with_categories(
        product_name=product_name,
        category_ids=selected_categories
    )

    all_categories = db.get_all_categories()

    return render_template('product_categories/list.html',
                        products=products,
                        all_categories=all_categories,
                        current_filters={
                            'product_name': product_name,
                            'categories': [int(cid) for cid in selected_categories]
                        })

@app.route('/product-categories/create', methods=['GET', 'POST'])
@login_required
def product_category_create():
    """Создание новой связи товар-категория"""
    if request.method == 'POST':
        product_id = request.form['product_id']
        category_id = request.form['category_id']

        if db.create_product_category_relation(product_id, category_id):
            flash('Связь успешно создана', 'success')
            return redirect(url_for('product_category_list'))
        else:
            flash('Ошибка при создании связи', 'danger')

    products = db.get_all_products()
    categories = db.get_all_categories()
    return render_template('product_categories/create.html',
                         products=products,
                         categories=categories)

@app.route('/product-categories/edit/<int:product_id>', methods=['GET', 'POST'])
@login_required
def product_category_edit(product_id):
    if request.method == 'POST':
        category_ids = request.form.getlist('categories')

        if db.update_product_categories(product_id, category_ids):
            flash('Категории товара успешно обновлены', 'success')
        else:
            flash('Ошибка при обновлении категорий товара', 'danger')
        return redirect(url_for('product_category_list'))

    sql = """
    SELECT p.id_product, p.Title,
           GROUP_CONCAT(c.id_category) as current_category_ids
    FROM Product p
    LEFT JOIN Product_to_Category ptc ON p.id_product = ptc.Product_id_product
    LEFT JOIN Category c ON ptc.Category_id_category = c.id_category
    WHERE p.id_product = %s
    GROUP BY p.id_product
    """
    with db.get_connection() as connection:
        with connection.cursor() as cursor:
            cursor.execute(sql, (product_id,))
            product = cursor.fetchone()

    if not product:
        flash('Товар не найден', 'danger')
        return redirect(url_for('product_category_list'))

    all_categories = db.get_all_categories()

    current_category_ids = []
    if product['current_category_ids']:
        current_category_ids = [int(id) for id in product['current_category_ids'].split(',')]

    return render_template('product_categories/edit.html',
                         product=product,
                         all_categories=all_categories,
                         current_category_ids=current_category_ids)

@app.route('/product-categories/delete/<int:relation_id>', methods=['POST'])
@login_required
def product_category_delete(relation_id):
    """Удаление связи товар-категория"""
    if db.delete_product_category_relation(relation_id):
        flash('Связь успешно удалена', 'success')
    else:
        flash('Ошибка при удалении связи', 'danger')
    return redirect(url_for('product_category_list'))

# Маршруты для входа
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        login = request.form['login']
        password = request.form['password']

        user = db.authenticate_user(login, password)
        if user:
            session['user'] = {
                'login': user['Login'],
                'lastname': user['Lastname'],
                'firstname': user['Firstname']
            }
            flash('Вы успешно авторизовались', 'success')
            return redirect(url_for('product_list'))
        else:
            flash('Неверный логин или пароль', 'danger')

    return render_template('auth/login.html')

@app.route('/logout')
def logout():
    session.pop('user', None)
    session.pop('cart', None)
    flash('Вы вышли из системы', 'info')
    return redirect(url_for('login'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        login = request.form['login']
        password = request.form['password']
        lastname = request.form['lastname']
        firstname = request.form['firstname']
        patronymic = request.form.get('patronymic')
        birthday = request.form.get('birthday')
        email = request.form.get('email')
        phone = request.form.get('phone')

        if birthday:
            try:
                datetime.strptime(birthday, '%Y-%m-%d')
            except ValueError:
                flash('Некорректный формат даты рождения. Используйте ГГГГ-ММ-ДД', 'danger')
                return redirect(url_for('register'))

        if db.create_user(login, password, lastname, firstname, patronymic, birthday, email, phone):
            flash('Регистрация прошла успешно. Теперь вы можете войти.', 'success')
            return redirect(url_for('login'))
        else:
            flash('Пользователь с таким логином уже существует', 'danger')

    return render_template('auth/register.html', datetime=datetime)

# Маршруты для избранного
@app.route('/favorites')
@login_required
def favorites():
    favorites = db.get_user_favorites(session['user']['login'])
    return render_template('user/favorites.html', favorites=favorites)

@app.route('/add_to_favorites/<int:product_id>', methods=['POST'])
@login_required
def add_to_favorites(product_id):
    if db.add_to_favorites(session['user']['login'], product_id):
        flash('Товар добавлен в избранное', 'success')
    else:
        flash('Товар уже в избранном или произошла ошибка', 'warning')
    return redirect(request.referrer or url_for('product_list'))

@app.route('/delete_from_favorites/<int:product_id>', methods=['POST'])
@login_required
def delete_from_favorites(product_id):
    if db.delete_from_favorites(session['user']['login'], product_id):
        flash('Товар удален из избранного', 'success')
    else:
        flash('Ошибка при удалении из избранного', 'danger')
    return redirect(url_for('favorites'))


# Временное хранилище корзины на время сессии
@app.before_request
def before_request():
    if 'cart' not in session:
        session['cart'] = {}

# Маршруты для корзины
@app.route('/cart')
@login_required
def cart():
    cart_items = []
    total = 0

    for product_id, quantity in session['cart'].items():
        product = db.get_product_by_id(product_id)
        if product:
            product['quantity'] = quantity
            product['total_price'] = product['Price'] * quantity
            total += product['total_price']
            cart_items.append(product)

    return render_template('user/cart.html', cart_items=cart_items, total=total)

@app.route('/add_to_cart/<int:product_id>', methods=['POST'])
@login_required
def add_to_cart(product_id):
    if str(product_id) in session['cart']:
        session['cart'][str(product_id)] += 1
    else:
        session['cart'][str(product_id)] = 1
    session.modified = True
    flash('Товар добавлен в корзину', 'success')
    return redirect(request.referrer or url_for('product_list'))

@app.route('/remove_from_cart/<int:product_id>', methods=['POST'])
@login_required
def remove_from_cart(product_id):
    if str(product_id) in session['cart']:
        del session['cart'][str(product_id)]
        session.modified = True
        flash('Товар удален из корзины', 'success')
    return redirect(url_for('cart'))

@app.route('/update_cart/<int:product_id>', methods=['POST'])
@login_required
def update_cart(product_id):
    quantity = int(request.form.get('quantity', 1))
    if quantity > 0:
        session['cart'][str(product_id)] = quantity
        session.modified = True
    else:
        del session['cart'][str(product_id)]
        session.modified = True
    return redirect(url_for('cart'))

@app.route('/checkout', methods=['POST'])
@login_required
def checkout():
    try:
        if not session.get('cart') or len(session['cart']) == 0:
            flash('Ваша корзина пуста', 'warning')
            return redirect(url_for('cart'))

        delivery_method = request.form.get('delivery_method')
        payment_method = request.form.get('payment_method')
        address = request.form.get('address')

        if not delivery_method or not address:
            flash('Пожалуйста, заполните все обязательные поля', 'danger')
            return redirect(url_for('cart'))

        order_data = {
            'delivery_method': delivery_method,
            'address': address,
            'payment_method': payment_method,
            'buyer_login': session['user']['login'],
            'cart_items': session['cart']
        }

        order_result = db.create_order(order_data)

        if order_result:
            session.pop('cart', None)
            flash('Заказ успешно оформлен! Номер вашего заказа: {}'.format(order_result['order_number']), 'success')
            return redirect(url_for('user_my_orders'))
        else:
            flash('Произошла ошибка при оформлении заказа', 'danger')
            return redirect(url_for('cart'))

    except Exception as e:
        print(f"Ошибка при оформлении заказа: {str(e)}")
        flash('Произошла ошибка при оформлении заказа', 'danger')
        return redirect(url_for('cart'))

if __name__ == '__main__':
    app.run(debug=True)
