-- Creación del usuario
CREATE USER 'santiago'@'localhost' IDENTIFIED BY 'santiago';
GRANT SELECT ON dsdetenidosaprehendidos TO 'santiago' @'localhost';

-- Creación de tablas
CREATE TABLE provincias (
    codigo_provincia VARCHAR(3) NOT NULL,
    nombre_provincia VARCHAR(35) NOT NULL,
    tasa_pobreza FLOAT,
    tasa_empleo_adecuado FLOAT,
    tasa_analfabetismo FLOAT,
    poblacion INT,
    PRIMARY KEY (codigo_provincia)
);

CREATE TABLE cantones (
    codigo_canton INT NOT NULL,
    nombre_canton VARCHAR(50) NOT NULL,
    codigo_provincia VARCHAR(3) NOT NULL,
    PRIMARY KEY (codigo_canton),
    FOREIGN KEY (codigo_provincia) REFERENCES provincias (codigo_provincia)
);

CREATE TABLE parroquias (
    codigo_parroquia INT NOT NULL,
    nombre_parroquia VARCHAR(50) NOT NULL,
    codigo_canton INT NOT NULL,
    PRIMARY KEY (codigo_parroquia),
    FOREIGN KEY (codigo_canton) REFERENCES cantones (codigo_canton)
);

CREATE TABLE zonas (
    id_zona INT NOT NULL AUTO_INCREMENT,
    nombre_zona VARCHAR(6) NOT NULL,
    PRIMARY KEY (id_zona)
);

CREATE TABLE subzonas (
    id_subzona INT NOT NULL AUTO_INCREMENT,
    nombre_subzona VARCHAR(50) NOT NULL,
    id_zona INT NOT NULL,
    PRIMARY KEY (id_subzona),
    FOREIGN KEY (id_zona) REFERENCES zonas (id_zona)
);

CREATE TABLE distritos (
    codigo_distrito VARCHAR(5) NOT NULL,
    nombre_distrito VARCHAR(25) NOT NULL,
    id_subzona INT NOT NULL,
    PRIMARY KEY (codigo_distrito),
    FOREIGN KEY (id_subzona) REFERENCES subzonas (id_subzona)
);

CREATE TABLE circuitos (
    codigo_circuito VARCHAR(8) NOT NULL,
    nombre_circuito VARCHAR(30) NOT NULL,
    codigo_distrito VARCHAR(5) NOT NULL,
    PRIMARY KEY (codigo_circuito),
    FOREIGN KEY (codigo_distrito) REFERENCES distritos (codigo_distrito)
);

CREATE TABLE subcircuitos (
    codigo_subcircuito VARCHAR(11) NOT NULL,
    infraestructura VARCHAR(10),
    numero_infraestructuras INT,
    nombre_subcircuito VARCHAR(30) NOT NULL,
    codigo_circuito VARCHAR(8) NOT NULL,
    PRIMARY KEY (codigo_subcircuito),
    FOREIGN KEY (codigo_circuito) REFERENCES circuitos (codigo_circuito)
);

CREATE TABLE armas (
    id_arma INT NOT NULL AUTO_INCREMENT,
    arma VARCHAR(20),
    tipo_arma VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_arma)
);

CREATE TABLE nacionalidades (
    id_nacionalidad INT NOT NULL AUTO_INCREMENT,
    nacionalidad VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_nacionalidad)
);

CREATE TABLE infracciones (
    id_infraccion INT NOT NULL AUTO_INCREMENT,
    presunta_infraccion VARCHAR(250) NOT NULL,
    PRIMARY KEY (id_infraccion)
);

CREATE TABLE subinfracciones (
    id_subinfraccion INT NOT NULL AUTO_INCREMENT,
    presunta_subinfraccion VARCHAR(250) NOT NULL,
    codigo_iccs VARCHAR(10),
    id_infraccion INT,
    PRIMARY KEY (id_subinfraccion),
    FOREIGN KEY (id_infraccion) REFERENCES infracciones (id_infraccion)
);

CREATE TABLE lugares (
    id_lugar INT NOT NULL AUTO_INCREMENT,
    lugar VARCHAR(50) NOT NULL,
    tipo_lugar VARCHAR(55),
    PRIMARY KEY (id_lugar)
);

CREATE TABLE detenidos_aprendidos (
    id_dete_apre INT NOT NULL AUTO_INCREMENT,
    edad SMALLINT,
    sexo VARCHAR(25),
    genero VARCHAR(20),
    autoidentificacion_etnica VARCHAR(50),
    numero_detenciones SMALLINT,
    nivel_de_instruccion VARCHAR(50),
    estado_civil VARCHAR(15),
    estatus_migratorio VARCHAR(10),
    id_nacionalidad INT,
    PRIMARY KEY (id_dete_apre),
    FOREIGN KEY (id_nacionalidad) REFERENCES nacionalidades (id_nacionalidad)
);

CREATE TABLE delitos (
    id_delito INT NOT NULL AUTO_INCREMENT,
    fecha_detencion_aprehension DATE NOT NULL,
    hora_detencion_aprehension TIME,
    movilizacion VARCHAR(15),
    tipo VARCHAR(15),
    presunta_flagrancia CHAR(2),
    presunta_modalidad TEXT,
    condicion VARCHAR(100),
    id_subinfraccion INT,
    id_dete_apre INT NOT NULL,
    id_arma INT,
    id_lugar INT,
    codigo_subcircuito VARCHAR(11),
    codigo_parroquia INT,
    PRIMARY KEY (id_delito),
    UNIQUE KEY (id_dete_apre),
    FOREIGN KEY (id_arma) REFERENCES armas (id_arma),
    FOREIGN KEY (id_dete_apre) REFERENCES detenidos_aprendidos (id_dete_apre),
    FOREIGN KEY (id_lugar) REFERENCES lugares (id_lugar),
    FOREIGN KEY (codigo_subcircuito) REFERENCES subcircuitos (codigo_subcircuito),
    FOREIGN KEY (codigo_parroquia) REFERENCES parroquias (codigo_parroquia),
    FOREIGN KEY (id_subinfraccion) REFERENCES subinfracciones (id_subinfraccion)
);

-- Insersión de datos
INSERT INTO provincias( codigo_provincia,
                        nombre_provincia,
                        tasa_pobreza,
                        tasa_empleo_adecuado,
                        tasa_analfabetismo,
                        poblacion)
SELECT DISTINCT df.codigo_provincia,
       df.nombre_provincia,
       da.tasa_pobreza,
       da.tasa_empelo_adecuado,
       da.tasa_analfabetismo,
       da.poblacion
FROM dsdetenidosaprehendidos df
JOIN dataAdicional da ON df.codigo_provincia = da.codigo_provincia
                             AND df.nombre_provincia = da.nombre_provincia
ORDER BY df.codigo_provincia;

INSERT INTO cantones(
                     codigo_canton,
                     nombre_canton ,
                     codigo_provincia)
SELECT DISTINCT codigo_canton, nombre_canton, codigo_provincia
FROM dsdetenidosaprehendidos d
WHERE codigo_canton IS NOT NULL
  AND codigo_provincia NOT IN ('DMG', 'DMQ')
  AND codigo_provincia BETWEEN 0 AND 8
ORDER BY codigo_canton;

INSERT INTO cantones(
                     codigo_canton,
                     nombre_canton ,
                     codigo_provincia)
SELECT DISTINCT codigo_canton, nombre_canton, codigo_provincia
FROM dsdetenidosaprehendidos d
WHERE codigo_canton IS NOT NULL
  AND codigo_provincia NOT IN ('DMG', 'DMQ')
  AND codigo_canton BETWEEN 901 AND 9004
ORDER BY codigo_canton;

INSERT INTO parroquias(
                     codigo_parroquia,
                     nombre_parroquia ,
                     codigo_canton)
SELECT DISTINCT codigo_parroquia, nombre_parroquia ,codigo_canton
FROM dsdetenidosaprehendidos
WHERE codigo_parroquia IS NOT NULL
  AND codigo_canton BETWEEN 0 AND 405
ORDER BY codigo_parroquia;

INSERT INTO parroquias(
                     codigo_parroquia,
                     nombre_parroquia ,
                     codigo_canton)
SELECT DISTINCT codigo_parroquia, nombre_parroquia ,codigo_canton
FROM dsdetenidosaprehendidos
WHERE codigo_parroquia IS NOT NULL
  AND codigo_parroquia BETWEEN 40650 AND 60161
ORDER BY codigo_parroquia
LIMIT 48;

INSERT INTO parroquias(
                     codigo_parroquia,
                     nombre_parroquia ,
                     codigo_canton)
SELECT DISTINCT codigo_parroquia, nombre_parroquia ,codigo_canton
FROM dsdetenidosaprehendidos
WHERE codigo_parroquia IS NOT NULL
  AND codigo_parroquia BETWEEN 60250 AND 100352
ORDER BY codigo_parroquia
LIMIT 226;

INSERT INTO parroquias(
                     codigo_parroquia,
                     nombre_parroquia ,
                     codigo_canton)
SELECT DISTINCT codigo_parroquia, nombre_parroquia ,codigo_canton
FROM dsdetenidosaprehendidos
WHERE codigo_parroquia IS NOT NULL
  AND codigo_parroquia BETWEEN 100353 AND 110553
ORDER BY codigo_parroquia;

INSERT INTO parroquias(
                     codigo_parroquia,
                     nombre_parroquia ,
                     codigo_canton)
SELECT DISTINCT codigo_parroquia, nombre_parroquia ,codigo_canton
FROM dsdetenidosaprehendidos
WHERE codigo_parroquia IS NOT NULL
  AND codigo_parroquia BETWEEN 110554 AND 130450
ORDER BY codigo_parroquia
LIMIT 1, 99;

INSERT INTO parroquias(
                     codigo_parroquia,
                     nombre_parroquia ,
                     codigo_canton)
SELECT DISTINCT codigo_parroquia, nombre_parroquia ,codigo_canton
FROM dsdetenidosaprehendidos
WHERE codigo_parroquia IS NOT NULL
  AND codigo_parroquia > 130450
ORDER BY codigo_parroquia;

INSERT INTO zonas(nombre_zona)
SELECT DISTINCT nombre_zona
FROM dsdetenidosaprehendidos
WHERE nombre_zona IS NOT NULL
ORDER BY nombre_zona;

INSERT INTO subzonas(nombre_subzona, id_zona)
SELECT DISTINCT nombre_subzona, z.id_zona
FROM dsdetenidosaprehendidos d
INNER JOIN (SELECT id_zona, nombre_zona
            FROM zonas) z ON d.nombre_zona = z.nombre_zona
ORDER BY nombre_subzona;

INSERT INTO distritos(codigo_distrito, nombre_distrito, id_subzona)
SELECT DISTINCT codigo_distrito, nombre_distrito, s.id_subzona
FROM dsdetenidosaprehendidos d
INNER JOIN (SELECT id_subzona, nombre_subzona, z.nombre_zona
            FROM subzonas s
            INNER JOIN zonas z ON s.id_zona = z.id_zona) s
    ON d.nombre_subzona = s.nombre_subzona
           AND d.nombre_zona = s.nombre_zona
WHERE codigo_distrito IS NOT NULL
ORDER BY codigo_distrito, s.id_subzona
LIMIT 1;

INSERT INTO distritos(codigo_distrito, nombre_distrito, id_subzona)
SELECT DISTINCT codigo_distrito, nombre_distrito, s.id_subzona
FROM dsdetenidosaprehendidos d
INNER JOIN (SELECT id_subzona, nombre_subzona, z.nombre_zona
            FROM subzonas s
            INNER JOIN zonas z ON s.id_zona = z.id_zona) s
    ON d.nombre_subzona = s.nombre_subzona
           AND d.nombre_zona = s.nombre_zona
WHERE codigo_distrito IS NOT NULL
  AND nombre_distrito <> ('LAS GOLONDRINAS')
ORDER BY codigo_distrito
LIMIT 2, 143;

INSERT INTO circuitos(
                    codigo_circuito,
                    nombre_circuito,
                    codigo_distrito)
SELECT DISTINCT codigo_circuito, nombre_circuito, codigo_distrito
FROM dsdetenidosaprehendidos
WHERE codigo_circuito IS NOT NULL
  AND nombre_circuito NOT IN ('LAS GOLONDRINAS', 'LEONIDAS PROAÃ?O')
ORDER BY codigo_circuito;

INSERT INTO subcircuitos(
                    codigo_subcircuito,
                    infraestructura,
                    numero_infraestructuras,
                    nombre_subcircuito,
                    codigo_circuito)
SELECT  DISTINCT df.codigo_subcircuito,
        da.infraestructura,
        da.numero_infraestructuras,
        df.nombre_subcircuito,
        df.codigo_circuito
FROM
    dsdetenidosaprehendidos df
JOIN
    dataAdicional da
ON
    df.codigo_subcircuito = da.codigo_subcircuito
AND df.nombre_subcircuito = da.nombre_subcircuito
ORDER BY df.codigo_subcircuito;

INSERT INTO armas(
                  arma,
                  tipo_arma)
SELECT DISTINCT arma, tipo_arma
FROM dsdetenidosaprehendidos
WHERE tipo_arma IS NOT NULL
ORDER BY arma;

INSERT INTO nacionalidades(
                  nacionalidad)
SELECT DISTINCT nacionalidad
FROM dsdetenidosaprehendidos
WHERE nacionalidad IS NOT NULL
ORDER BY nacionalidad;

INSERT INTO infracciones(
                  presunta_infraccion)
SELECT DISTINCT presunta_infraccion
FROM dsdetenidosaprehendidos
WHERE presunta_infraccion IS NOT NULL
ORDER BY presunta_infraccion;

INSERT INTO subinfracciones(presunta_subinfraccion, codigo_iccs, id_infraccion)
SELECT s.presunta_subinfraccion, s.codigo_iccs, i.id_infraccion
FROM (SELECT a.presunta_subinfraccion, a.codigo_iccs, a.presunta_infraccion
      FROM (SELECT DISTINCT presunta_subinfraccion, codigo_iccs, presunta_infraccion
            FROM dsdetenidosaprehendidos
            WHERE presunta_subinfraccion IS NOT NULL
              AND codigo_iccs IS NOT NULL
            ORDER BY presunta_subinfraccion) a
      UNION
      SELECT b.presunta_subinfraccion, b.codigo_iccs, b.presunta_infraccion
      FROM (SELECT i.presunta_subinfraccion, i.codigo_iccs, i.presunta_infraccion
            FROM (SELECT x.presunta_subinfraccion, x.codigo_iccs, x.presunta_infraccion
                  FROM (SELECT DISTINCT presunta_subinfraccion, codigo_iccs, presunta_infraccion
                        FROM dsdetenidosaprehendidos
                        WHERE presunta_subinfraccion NOT IN (SELECT DISTINCT presunta_subinfraccion
                                                             FROM dsdetenidosaprehendidos
                                                             WHERE codigo_iccs IS NOT NULL
                                                             ORDER BY presunta_subinfraccion)
                          AND presunta_subinfraccion IS NOT NULL
                        ORDER BY presunta_subinfraccion) x
                  WHERE x.presunta_subinfraccion IS NOT NULL
                    AND x.presunta_infraccion IS NOT NULL) i
            UNION
            SELECT j.presunta_subinfraccion, j.codigo_iccs, j.presunta_subinfraccion
            FROM (SELECT x.presunta_subinfraccion, x.codigo_iccs
                  FROM (SELECT DISTINCT presunta_subinfraccion, codigo_iccs, presunta_infraccion
                        FROM dsdetenidosaprehendidos
                        WHERE presunta_subinfraccion NOT IN (SELECT DISTINCT presunta_subinfraccion
                                                             FROM dsdetenidosaprehendidos
                                                             WHERE codigo_iccs IS NOT NULL
                                                             ORDER BY presunta_subinfraccion)
                          AND presunta_subinfraccion IS NOT NULL
                        ORDER BY presunta_subinfraccion) x
                  WHERE x.presunta_subinfraccion NOT IN (SELECT DISTINCT presunta_subinfraccion
                                                         FROM dsdetenidosaprehendidos
                                                         WHERE presunta_subinfraccion NOT IN
                                                               (SELECT DISTINCT presunta_subinfraccion
                                                                FROM dsdetenidosaprehendidos
                                                                WHERE codigo_iccs IS NOT NULL
                                                                ORDER BY presunta_subinfraccion)
                                                           AND presunta_subinfraccion IS NOT NULL
                                                           AND presunta_infraccion IS NOT NULL
                                                         ORDER BY presunta_subinfraccion)) j) b
      ORDER BY presunta_subinfraccion) s
         LEFT JOIN infracciones i ON s.presunta_infraccion = i.presunta_infraccion;

INSERT INTO lugares(
                  lugar,
                  tipo_lugar)
SELECT a.lugar, a.tipo_lugar
FROM (SELECT DISTINCT lugar, tipo_lugar
      FROM dsdetenidosaprehendidos
      WHERE lugar IS NOT NULL AND tipo_lugar IS NOT NULL
      ORDER BY lugar) a
UNION
SELECT b.lugar, b.tipo_lugar
FROM (SELECT DISTINCT lugar, tipo_lugar
      FROM dsdetenidosaprehendidos
      WHERE lugar NOT IN (SELECT DISTINCT lugar
                          FROM dsdetenidosaprehendidos
                          WHERE tipo_lugar IS NOT NULL
                          ORDER BY lugar)
        AND lugar IS NOT NULL
      ORDER BY lugar) b
ORDER BY lugar;

INSERT INTO detenidos_aprendidos(edad, sexo, genero, autoidentificacion_etnica, numero_detenciones,
                                 nivel_de_instruccion, estado_civil, estatus_migratorio, id_nacionalidad)
SELECT edad, sexo, genero, autoidentificacion_etnica, numero_detenciones,
       nivel_de_instruccion, estado_civil, estatus_migratorio, n.id_nacionalidad
FROM dsdetenidosaprehendidos d
LEFT JOIN nacionalidades n on d.nacionalidad = n.nacionalidad;

SET @row_number = 0;

INSERT INTO delitos(fecha_detencion_aprehension, hora_detencion_aprehension, movilizacion, tipo,
                    presunta_flagrancia, presunta_modalidad, condicion, id_subinfraccion, id_dete_apre,
                    id_arma, id_lugar, codigo_subcircuito, codigo_parroquia)
SELECT fecha_detencion_aprehension, hora_detencion_aprehension, movilizacion, tipo,
       presunta_flagrancia, presunta_movilidad, condicion, s.id_subinfraccion,
       (@row_number := @row_number + 1) AS id_dete_apre, a.id_arma, l.id_lugar,
       s2.codigo_subcircuito, p.codigo_parroquia
FROM dsdetenidosaprehendidos d
LEFT JOIN subinfracciones s ON d.presunta_subinfraccion = s.presunta_subinfraccion
                                   AND d.codigo_iccs = s.codigo_iccs
LEFT JOIN armas a ON d.arma = a.arma AND d.tipo_arma = a.tipo_arma
LEFT JOIN lugares l ON d.lugar = l.lugar AND d.tipo_lugar = l.tipo_lugar
LEFT JOIN subcircuitos s2 ON d.codigo_circuito = s2.codigo_circuito
                                 AND d.nombre_subcircuito = s2.nombre_subcircuito
LEFT JOIN parroquias p ON d.codigo_parroquia = p.codigo_parroquia
                              AND d.nombre_parroquia = p.nombre_parroquia;

-- Eliminar tablas temporales
DROP TABLE dsdetenidosaprehendidos;
DROP TABLE dataadicional;