/* Nivell 1

Exercici 1 - A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules. 
Mostra les característiques principals de l'esquema creat i explica les diferents taules i variables que existeixen. 
Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables. */

USE transactions;

/* Exercici 2 - Utilitzant JOIN realitzaràs les següents consultes:

Llistat dels països que estan generant vendes. */
SELECT DISTINCT c.country AS lista_paises
FROM company c 
JOIN transaction t ON c.id = t.company_id
WHERE t.declined = 0;

/* Des de quants països es generen les vendes. */
SELECT COUNT(DISTINCT c.country) AS cuento_paises 
FROM company c 
JOIN transaction t ON c.id = t.company_id
WHERE t.declined = 0;

/* Identifica la companyia amb la mitjana més gran de vendes. */
SELECT c.id, c.company_name, ROUND(AVG(t.amount),2) AS media_ventas
FROM company c 
JOIN transaction t ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.id, c.company_name
ORDER BY media_ventas DESC
LIMIT 1;

/* Exercici 3 - Utilitzant només subconsultes (sense utilitzar JOIN):

Mostra totes les transaccions realitzades per empreses d'Alemanya. */
SELECT * 
FROM transaction
WHERE company_id IN(SELECT id
					FROM company
					WHERE country = 'Germany');

/*Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions. */
SELECT company_name
FROM company
WHERE id IN (SELECT DISTINCT company_id
			 FROM transaction
			 WHERE amount > (SELECT AVG(amount)
							 FROM transaction));

/* Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses. */
SELECT company_name
FROM company
WHERE id NOT IN (SELECT DISTINCT company_id
				 FROM transaction);

/* Exercici 4
La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. La nova taula 
ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company"). 
Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". 
Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.*/
CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(15) PRIMARY KEY,
	iban VARCHAR(255),
	pan VARCHAR(50), 
	pin VARCHAR(50), 
	cvv VARCHAR(50), 
	expiring_date VARCHAR(50)
	);

ALTER TABLE transaction
ADD CONSTRAINT fk_credit_card_id
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);

/*Exercici 5 - El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938. 
La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.*/
SELECT * 
FROM credit_card
WHERE id = 'CcU-2938';

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT * 
FROM credit_card
WHERE id = 'CcU-2938';

/*Exercici 6
En la taula "transaction" ingressa una nova transacció amb la següent informació:
Id = 108B1D1D-5B23-A76C-55EF-C568E49A99DD 
credit_card_id = CcU-9999 
company_id = b-9999 
user_id = 9999 
lat = 829.999 
longitude = -117.999 
amount = 111.11 
declined = 0 */
INSERT INTO company (id, company_name, phone, email, country, website) VALUES ('b-9999', 'Bulls company', '06 66 66 55 22', 'bulls@icloud.com', 'Australia', 'https://whatsapp.com/group/169');
INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date) VALUES ('CcU-9999', 'TR301940312213576817638661', '5424466566813633', '6666', '666', '10/30/22');
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '111.11', '0');

# Exercici 7 - Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.
ALTER TABLE credit_card
DROP COLUMN pan;

SELECT * 
FROM credit_card;

/*Exercici 8 - Descarrega els arxius CSV que trobaràs a l'apartat de recursos:
o	american_users.csv
o	european_users.csv
o	companies.csv
o	credit_cards.csv
o	transactions.csv
Estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les 
següents consultes:

La taula de products.csv l'utilitzarem més endavant.*/

-- Primero, creamos la base de datos
CREATE DATABASE IF NOT EXISTS transactions_star;

USE transactions_star;

-- Ahora vamos crear 4 tablas: company, user, credit_card y transaction 

-- Tabla company
CREATE TABLE IF NOT EXISTS company (
	company_id VARCHAR(15) PRIMARY KEY,
    company_name VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    country VARCHAR(100),
    website VARCHAR(255),
    merchant_category VARCHAR(100),
    merchant_price_position VARCHAR(100)
);

-- Tabla user
CREATE TABLE IF NOT EXISTS user (
	id INT PRIMARY KEY,
    name VARCHAR(50),
    surname VARCHAR(50),
    phone VARCHAR(50),
    email VARCHAR(100),
    birth_date VARCHAR(50),
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(50),
    address VARCHAR(100),
    signup_date VARCHAR(50),
    user_segment VARCHAR(50),
	income_band VARCHAR(50)
);

-- Tabla credit_card
CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(15) PRIMARY KEY,
	user_id INT REFERENCES user(id), 
	iban VARCHAR(50),
	pan VARCHAR(50),
	pin VARCHAR(10),
	cvv VARCHAR(10),
	track1 VARCHAR(100),
	track2 VARCHAR(100),
	expiring_date VARCHAR(10),
	card_type VARCHAR(50),
	card_renewal_flag BOOLEAN
);
    
-- Tabla transaction
CREATE TABLE IF NOT EXISTS transaction (
	id VARCHAR(255) PRIMARY KEY,
    card_id VARCHAR(15) REFERENCES credit_card(id),
    business_id VARCHAR(20) REFERENCES company(company_id), 
    timestamp TIMESTAMP,
    amount DECIMAL(10, 2),
    declined BOOLEAN,
    product_ids VARCHAR(50),
    user_id INT REFERENCES user(id),
    lat FLOAT,
    longitude FLOAT,
    discount_amount DECIMAL(10, 2),
    tax_amount DECIMAL(10, 2),
    shipping_amount DECIMAL(10, 2),
    channel VARCHAR(50),
    campaign_id VARCHAR(50),
    device_type VARCHAR(50),
    is_international BOOLEAN,
    decline_reason VARCHAR(100),
    distance_km DECIMAL(10, 2)
);

-- Insertamos datos de companies
LOAD DATA 
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__companies.csv'
INTO TABLE company
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- Insertamos datos de users
LOAD DATA 
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__american_users.csv'
INTO TABLE user
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

LOAD DATA 
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__european_users.csv'
INTO TABLE user
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- Insertamos datos de credit cards
LOAD DATA 
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__credit_cards.csv'
INTO TABLE credit_card
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- Insertamos datos de transactions
LOAD DATA 
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__transactions.csv'
INTO TABLE transaction
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

-- Creamos la columna región en la tabla de usuarios 
ALTER TABLE user
ADD region VARCHAR(100);

UPDATE user 
SET region = CASE WHEN country = 'United States' THEN 'America' 
			  WHEN country = 'Canada' THEN 'America'
			  ELSE 'Europa'
			  END
WHERE id >= 0;

SELECT id, country, region
FROM user;

-- Por fin, establecer las relaciones entre las tablas
ALTER TABLE transaction
ADD CONSTRAINT fk_card_id
FOREIGN KEY (card_id)
REFERENCES credit_card(id);

ALTER TABLE transaction
ADD CONSTRAINT fk_business_id
FOREIGN KEY (business_id)
REFERENCES company(company_id);

ALTER TABLE transaction
ADD CONSTRAINT fk_user_id
FOREIGN KEY (user_id)
REFERENCES user(id);

ALTER TABLE credit_card
ADD CONSTRAINT fk_card_user_id
FOREIGN KEY (user_id)
REFERENCES user(id);

/* Exercici 9 - Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.*/
SELECT id, name, surname
FROM user
WHERE id IN(SELECT user_id
			FROM transaction
			GROUP BY user_id
			HAVING COUNT(*) > 80);

/* Exercici 10 - Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.*/
SELECT c.iban, ROUND(AVG(amount),2) AS valor_medio
FROM transaction t
JOIN credit_card c ON t.card_id = c.id
WHERE t.business_id = (SELECT company_id
					   FROM company
					   WHERE company_name = 'Donec Ltd')
GROUP BY c.iban;

/* Nivell 2

Exercici 1 - Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
Mostra la data de cada transacció juntament amb el total de les vendes.*/
SELECT CONVERT(timestamp, DATE) AS date, ROUND(SUM(amount),2) AS ingressos
FROM transaction
WHERE declined = 0
GROUP BY date
ORDER BY ingressos DESC
LIMIT 5;

/*Exercici 2 - Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès 
entre 350 i 400 euros i en alguna d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. 
Ordena els resultats de major a menor quantitat.*/
SELECT c.company_name, c.phone, c.country, CONVERT(t.timestamp, DATE) AS date, t.amount
FROM transaction t
JOIN company c ON t.business_id = c.company_id 
WHERE CONVERT(t.timestamp, DATE) IN ('2015-04-29', '2018-07-20', '2024-03-13')
AND t.amount BETWEEN 350 AND 400
ORDER BY t.amount DESC;

/*Exercici 3 - Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa 
et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent 
i vol un llistat de les empreses on especifiquis si tenen igual o més de 400 transaccions o menys.*/ 
SELECT t.business_id, c.company_name, COUNT(*) as num_transacciones,
CASE WHEN COUNT(*) >= 400 THEN '400 o más' 
	 ELSE 'menos de 400'
	 END AS capacidad_operativa
FROM transaction t 
JOIN company c ON t.business_id = c.company_id 
GROUP BY t.business_id, c.company_name;

# Exercici 4 - Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.
SELECT *  
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

DELETE 
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

SELECT *  
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

/*Exercici 5 - La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. Serà necessària que creïs una 
vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. Telèfon de contacte. País de residència. 
Mitjana de compra realitzat per cada companyia. Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.*/
CREATE VIEW VistaMarketing AS
SELECT c.company_id, c.company_name, c.phone, c.country, AVG(t.amount) AS media_compras
FROM company c 
JOIN transaction t ON c.company_id = t.business_id
WHERE t.declined = 0
GROUP BY c.company_id, c.company_name, c.phone, c.country;

SELECT *
FROM VistaMarketing
ORDER BY media_compras DESC;

/* Nivell 3

Exercici 1 - Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions han estat 
declinades aleshores és inactiu, si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:*/
CREATE TABLE IF NOT EXISTS estado_tarjetas AS
	SELECT id AS card_id, 
	CASE WHEN SUM(declined) = 3 THEN 'Inactivo'
		 ELSE 'Activo'
		 END AS estado_tarjeta
	FROM (SELECT c.id, t.timestamp, t.declined, ROW_NUMBER() OVER (PARTITION BY c.id
																   ORDER BY t.timestamp DESC) AS position
		  FROM credit_card c
		  JOIN transaction t ON c.id = t.card_id) AS filtered_table
	WHERE position IN (1, 2, 3)
	GROUP BY id; 
            
# Quantes targetes estan actives?
SELECT COUNT(*) AS tarjetas_activas
FROM estado_tarjetas
WHERE estado_tarjeta = 'Activo';

/*Exercici 2 - Crea una taula amb la qual puguem unir les dades de l'arxiu de products.csv amb la base de dades creada 
(ja que fins ara no podíem fer-ho), tenint en compte que des de transaction tens product_ids. */

-- Creamos la tabla product
CREATE TABLE IF NOT EXISTS product (
	id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price VARCHAR(20),
    colour VARCHAR(100),
    weight DECIMAL(10, 2),
    warehouse_id VARCHAR(100),
    category VARCHAR(100),
    brand VARCHAR(100),
    cost VARCHAR(20),
    launch_date DATE
);

-- Inserimos los datos
LOAD DATA 
INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__products.csv'
INTO TABLE product
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

-- Creamos la tabla intermediaria 
CREATE TABLE join_transaction_product AS
SELECT t.id, t.card_id, t.business_id, t.timestamp, t.amount, t.declined, t.user_id, t.lat, t.longitude, t.discount_amount, t.tax_amount, t.shipping_amount, t.channel, t.campaign_id, t.device_type, t.is_international, t.decline_reason, t.distance_km, p.id AS product_id, p.product_name, p.price, p.colour, p.weight, p.warehouse_id, p.category, p.brand, p.cost, p.launch_date
FROM transaction t
JOIN product p ON FIND_IN_SET(p.id, REPLACE(t.product_ids, ' ', '')) > 0;

/* Genera la següent consulta:

Necessitem conèixer el nombre de vegades que s'ha venut cada producte.*/
SELECT product_id, COUNT(*) AS ventas_total
FROM join_transaction_product
WHERE declined = 0
GROUP BY product_id;