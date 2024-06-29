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
    nombre_zona VARCHAR(50) NOT NULL,
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
    arma VARCHAR(20) NOT NULL,
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
    presunta_subinfraccion VARCHAR(250),
    codigo_iccs VARCHAR(10),
    id_infraccion INT NOT NULL,
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
    numero_detenciones SMALLINT NOT NULL,
    nivel_de_instruccion VARCHAR(50),
    estado_civil VARCHAR(15),
    estatus_migratorio VARCHAR(10),
    id_nacionalidad INT NOT NULL,
    PRIMARY KEY (id_dete_apre),
    FOREIGN KEY (id_nacionalidad) REFERENCES nacionalidades (id_nacionalidad)
);

CREATE TABLE delitos (
    id_delito INT NOT NULL AUTO_INCREMENT,
    fecha_detencion_aprehension DATE NOT NULL,
    hora_detencion_aprehension TIME NOT NULL,
    movilizacion VARCHAR(15),
    tipo VARCHAR(15),
    presunta_flagrancia CHAR(2) NOT NULL,
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
FROM dataframebueno df
JOIN dataAdicional da ON df.codigo_provincia = da.codigo_provincia
AND df.nombre_provincia = da.nombre_provincia
ORDER BY df.codigo_provincia;

INSERT INTO cantones(
                     codigo_canton,
                     nombre_canton ,
                     codigo_provincia)
SELECT DISTINCT codigo_canton, nombre_canton ,codigo_provincia
FROM dataframebueno
WHERE codigo_canton IS NOT NULL
ORDER BY codigo_canton;

INSERT INTO parroquias(
                     codigo_parroquia,
                     nombre_parroquia ,
                     codigo_canton)
SELECT DISTINCT codigo_parroquia, nombre_parroquia ,codigo_canton
FROM dataframebueno
WHERE codigo_canton IS NOT NULL
ORDER BY codigo_parroquia;

INSERT INTO zonas(nombre_zona)
SELECT DISTINCT nombre_zona
FROM dataframebueno
ORDER BY nombre_zona;

INSERT INTO subzonas(nombre_subzona)
SELECT DISTINCT nombre_subzona
FROM dataframebueno
ORDER BY nombre_subzona;

INSERT INTO distritos(codigo_distrito,
                     nombre_distrito)
SELECT DISTINCT codigo_distrito, nombre_distrito
FROM dataframebueno
WHERE codigo_distrito IS NOT NULL
ORDER BY codigo_distrito;

INSERT INTO circuitos(
                    codigo_circuito,
                    nombre_circuito,
                    codigo_distrito)
SELECT DISTINCT codigo_circuito, nombre_circuito, codigo_distrito
FROM dataframebueno
WHERE codigo_circuito IS NOT NULL
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
    dataframebueno df
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
FROM dataframebueno
WHERE tipo_arma IS NOT NULL
ORDER BY arma;

INSERT INTO nacionalidades(
                  nacionalidad)
SELECT DISTINCT nacionalidad
FROM dataframebueno
WHERE nacionalidad IS NOT NULL
ORDER BY nacionalidad;

INSERT INTO infracciones(
                  presunta_infraccion)
SELECT DISTINCT presunta_infraccion
FROM dataframebueno
WHERE presunta_infraccion IS NOT NULL
ORDER BY presunta_infraccion;

INSERT INTO subinfracciones(presunta_subinfraccion,
                            codigo_iccs)
SELECT DISTINCT presunta_subinfraccion, codigo_iccs
FROM dataframebueno
ORDER BY presunta_subinfraccion;

INSERT INTO lugares(
                  lugar,
                  tipo_lugar)
SELECT DISTINCT lugar, tipo_lugar
FROM dataframebueno
ORDER BY lugar;

INSERT INTO detenidos_aprendidos(
                    edad,
                    sexo,
                    genero,
                    autoidentificacion_etnica,
                    numero_detenciones,
                    nivel_de_instruccion,
                    estado_civil,
                    estatus_migratorio)
SELECT edad, sexo, genero, autoidentificacion_etnica, numero_detenciones, nivel_de_instruccion, estado_civil, estatus_migratorio
FROM dataframebueno;

INSERT INTO delitos(
                    fecha_detencion_aprehension,
                    hora_detencion_aprehension,
                    movilizacion,
                    tipo,
                    presunta_flagrancia,
                    presunta_modalidad,
                    condicion)
SELECT fecha_detencion_aprehension, hora_detencion_aprehension, movilizacion, tipo, presunta_flagrancia, presunta_modalidad, condicion
FROM dataframebueno;