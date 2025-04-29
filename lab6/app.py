from flask import Flask, render_template, request, redirect, url_for, flash
from db_queries import DatabaseManager
import pymysql

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
def product_list():
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

    products = db.get_filtered_products(**filters)

    all_makers = db.get_all_makers()
    all_categories = db.get_all_categories()

    return render_template('products/list.html',
                         products=products,
                         all_makers=all_makers,
                         all_categories=all_categories,
                         current_filters=request.args)

@app.route('/products/create', methods=['GET', 'POST'])
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
def product_edit(product_id):
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
def product_delete(product_id):
    if db.delete_product(product_id):
        flash('Товар успешно удален', 'success')
    else:
        flash('Ошибка при удалении товара', 'danger')
    return redirect(url_for('product_list'))

# Маршруты для производителей
@app.route('/makers')
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
def maker_delete(maker_id):
    if db.delete_maker(maker_id):
        flash('Производитель успешно удален', 'success')
    else:
        flash('Ошибка при удалении производителя', 'danger')
    return redirect(url_for('maker_list'))

# Маршрут для категорий
@app.route('/categories')
def category_list():
    categories = db.get_all_categories()
    return render_template('categories/list.html', categories=categories)

# Аналитические запросы
@app.route('/analytics/product_categories')
def product_categories():
    product_name = request.args.get('product_name', '').strip()

    if product_name:
        products = db.get_products_by_name_substring(product_name)
        return render_template('analytics/product_categories.html',
                            product_name=product_name,
                            products=products)

    return render_template('analytics/product_categories.html')

@app.route('/analytics/user_orders')
def user_orders():
    login = request.args.get('login')
    if login:
        orders = db.get_user_orders(login)
        return render_template('analytics/user_orders.html',
                            login=login,
                            orders=orders)
    return render_template('analytics/user_orders.html')


if __name__ == '__main__':
    app.run(debug=True)
