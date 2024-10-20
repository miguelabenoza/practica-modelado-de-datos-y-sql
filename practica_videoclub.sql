create schema if not exists miguel_practica_videoclub;
set schema 'miguel_practica_videoclub';


create table if not exists alquiler (
	id_alquiler serial primary key,
	fecha_alquiler date not null,
	fecha_devolucion date,
	
	id_socio integer not null,
	id_copia integer not null
);

create table if not exists socio (
	id_socio serial primary key,
	nombre varchar(30) not null,
	apellidos varchar(70) not null,
	fecha_nacimiento date not null,
	telefono varchar(50) not null,
	dni varchar(9) not null
);

create table if not exists direccion (
	id_socio integer primary key,
	calle varchar(50),
	numero varchar(5),
	piso varchar(10),
	ext varchar(10),
	codigo_postal varchar(5)
);

create table if not exists copia (
	id_copia serial primary key,
	
	id_pelicula integer not null
);

create table if not exists pelicula (
	id_pelicula serial primary key,
	titulo varchar(70) not null,
	sinopsis text not null,
	
	id_genero integer not null,
	id_director integer not null
);

create table if not exists director (
	id_director serial primary key,
	nombre_director varchar(80) not null
);

create table if not exists genero (
	id_genero serial primary key,
	nombre_genero varchar(50) not null
);



alter table alquiler add constraint id_socio_fk foreign key(id_socio) references socio(id_socio);
alter table alquiler add constraint id_copia_fk foreign key(id_copia) references copia(id_copia);
alter table direccion add constraint direccion_socio_fk foreign key(id_socio) references socio(id_socio);
alter table copia add constraint id_pelicula_fk foreign key(id_pelicula) references pelicula(id_pelicula);
alter table pelicula add constraint id_genero_fk foreign key(id_genero) references genero(id_genero);
alter table pelicula add constraint id_director_fk foreign key(id_director) references director(id_director);

	
insert into director(nombre_director) select distinct director from tmp_videoclub;
insert into genero(nombre_genero) select distinct genero from tmp_videoclub;
insert into pelicula(titulo,sinopsis,id_genero,id_director) select distinct tmp.titulo, tmp.sinopsis, g.id_genero, d.id_director from tmp_videoclub tmp left join genero g on g.nombre_genero = tmp.genero left join director d on d.nombre_director = tmp.director;
insert into copia(id_copia,id_pelicula) select distinct tmp.id_copia, p.id_pelicula from tmp_videoclub tmp left join pelicula p on p.titulo = tmp.titulo;
insert into socio (nombre, apellidos, fecha_nacimiento,telefono,dni) select distinct tmp.nombre, concat(tmp.apellido_1, ' ', tmp.apellido_2) as apellidos, cast(tmp.fecha_nacimiento as date) fecha_nacimiento, tmp.telefono, tmp.dni from tmp_videoclub tmp;
insert into alquiler(fecha_alquiler,fecha_devolucion,id_socio,id_copia) select distinct tmp.fecha_alquiler, tmp.fecha_devolucion, s.id_socio, c.id_copia from tmp_videoclub tmp join socio s on s.dni = tmp.dni join copia c on c.id_copia = tmp.id_copia;


/* Consulta */
select p.titulo, count(c.id_copia) as "Copias disponibles"
from pelicula p
left join copia c on c.id_pelicula = p.id_pelicula
left join alquiler al on al.id_copia = c.id_copia and al.fecha_devolucion is null
where al.id_copia is null
group by p.id_pelicula

	
	
	
	
	
	
	
	