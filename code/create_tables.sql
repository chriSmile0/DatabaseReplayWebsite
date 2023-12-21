--creatiion

create table UTILISATEUR
(
    id_user number(10) NOT NULL,
    login varchar2(128) NOT NULL,
    password varchar2(30) NOT NULL,
    nom varchar2(30),
    prenom varchar2(30),
    date_naissance DATE,
    email varchar2(70),
    langue varchar2(40),
    CONSTRAINT PK_utilisateur PRIMARY KEY (id_user)
);


create table EMISSION 
(
    id_emi number(10) NOT NULL,
    nom_emi varchar2(60) NOT NULL,
    CONSTRAINT PK_emission PRIMARY KEY (id_emi)
);

create table CATEGORIE 
(
    categorie varchar2(20) NOT NULL,
    CONSTRAINT PK_categorie PRIMARY KEY (categorie)
); 

create table CATEGORIE_EMISSION 
(
    id_emi number(10) NOT NULL,
    categorie varchar2(20) NOT NULL,
    CONSTRAINT PK_categorie_emission PRIMARY KEY (id_emi),
    CONSTRAINT FK_categorie_emission_cate FOREIGN KEY (categorie) REFERENCES CATEGORIE (categorie),
    CONSTRAINT FK_categorie_emission_emi FOREIGN KEY (id_emi) REFERENCES EMISSION
);

create table UTILISATEUR_CATEGORIE
(
    id_user number(10) NOT NULL,
    categorie varchar2(20) NOT NULL,
    CONSTRAINT PK_interesser PRIMARY KEY(id_user,categorie),
    CONSTRAINT FK_interesser_par_c FOREIGN KEY (categorie) REFERENCES CATEGORIE,
    CONSTRAINT FK_interesser_de FOREIGN KEY (id_user) REFERENCES UTILISATEUR 
);


create table VIDEO
(
    id_video number(10) NOT NULL,
    id_emi number(10)  NOT NULL,
    nom_v varchar2(100) NOT NULL,
    date_diffusion timestamp,
    descriptif varchar2(200),
    pays_origine varchar2(20),
    duree number(3), -- on estime en minute 
    multilingue char(1) DEFAULT NULL,
    CONSTRAINT PK_video PRIMARY KEY (id_video),
    CONSTRAINT FK_video_emission FOREIGN KEY (id_emi) REFERENCES EMISSION,
    CONSTRAINT CK_multilingue CHECK(multilingue in ('O','N'))
);

create table HISTORIQUE
(
    id_user number(10) NOT NULL,
    id_video number(10) NOT NULL,
    date_visionnage timestamp,
    -- il faudra aussi verifier que la date de visionnage est bien superieur à a la date de diffusion , du moins la dernière en date 
    -- ou de verifier de quand date la premiere diffusion de cette video
    CONSTRAINT FK_histo_utilisateur FOREIGN KEY (id_user) REFERENCES UTILISATEUR,
    CONSTRAINT FK_histo_video FOREIGN KEY (id_video) REFERENCES VIDEO
);


create table FAVORIS
(
    id_user number(10) NOT NULL,
    id_video number(10) NOT NULL,
    CONSTRAINT PK_favoris PRIMARY KEY (id_user,id_video),
    CONSTRAINT FK_favoris_utilisateur FOREIGN KEY (id_user) REFERENCES UTILISATEUR,
    CONSTRAINT FK_favoris_video FOREIGN KEY (id_video) REFERENCES VIDEO (id_video)
);

create table ABONNEMENT 
(
    id_user number(10) NOT NULL,
    id_emi number(10) NOT NULL,
    CONSTRAINT PK_abonnement PRIMARY KEY (id_user,id_emi),
    CONSTRAINT FK_abonnement_utilisateur FOREIGN KEY (id_user) REFERENCES UTILISATEUR,
    CONSTRAINT FK_abonnement_emission FOREIGN KEY (id_emi) REFERENCES EMISSION
);


create table SUGGESTIONS
(
    id_user number(10) NOT NULL,
    id_video number(10) NOT NULL,
    CONSTRAINT PK_suggestions PRIMARY KEY (id_user,id_video),
    CONSTRAINT FK_suggestions_utilisateur FOREIGN KEY (id_user) REFERENCES UTILISATEUR,
    CONSTRAINT FK_suggestions_video FOREIGN KEY (id_video) REFERENCES VIDEO ON DELETE CASCADE
);


create table ARCHIVES 
(
    id_archive number(10) NOT NULL,
    id_video number(10) NOT NULL,
    id_emi number(10)  NOT NULL,
    nom_v varchar2(100) NOT NULL,
    descriptif varchar2(200),
    pays_origine varchar2(20),
    duree number(3), -- on estime en minute 
    CONSTRAINT PK_archives PRIMARY KEY (id_archive)
);

create table NEWSLETTER 
(
    id_news number(10) NOT NULL,
    texte varchar2(512) NOT NULL,
    CONSTRAINT PK_newsletter PRIMARY KEY (id_news)
);

