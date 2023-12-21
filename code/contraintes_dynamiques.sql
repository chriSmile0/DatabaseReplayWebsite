-- contraintes dynamiques
-- Contrainte dynamique 1
CREATE TRIGGER verif_nb_favoris
BEFORE INSERT ON FAVORIS
FOR EACH ROW
DECLARE
    max_favoris_v NUMBER;
BEGIN
    Select count(id_user) INTO max_favoris_v from FAVORIS where id_user = :new.id_user;
    IF max_favoris_v > 300
        THEN 
        RAISE_APPLICATION_ERROR(-20002,'Pas de plus de 300 favoris par utilisateur');

    END IF;
END;
/

-- Contrainte dynamique 2
-- modification de la date de diffusion
/*CREATE TRIGGER maj_date_emission
AFTER INSERT ON VIDEO
FOR EACH ROW
DECLARE
BEGIN

END;
/*/


-- Contrainte dynamique 3
-- apres suppression on va dans archives
CREATE TRIGGER go_archives
BEFORE DELETE ON VIDEO
FOR EACH ROW
DECLARE
newId NUMBER;
BEGIN
    SELECT max(id_archive) INTO newId FROM archives ;
    IF newId Is NULL
        THEN
        newId := 0;
    ENd IF;
   
    newId := newId + 1;  
    INSERT INTO archives
    VALUES (newId,:old.id_video,:old.id_emi,:old.nom_v,:old.descriptif,:old.pays_origine,:old.duree);

END;
/

-- Contrainte dynamique 4
-- Pas plus de 3 visionnage par minute
-- on estime donc que dans l'historique on ne peut
-- pas voir un même utilisateur qui a vu la video
-- 3 fois dans la meme minute
CREATE Or REPLACE TRIGGER visionnages
BEFORE INSERT ON HISTORIQUE
FOR EACH ROW
DECLARE
date_first HISTORIQUE.date_visionnage%type;
nb_video_vu_min_v NUMBER;
BEGIN
    Select max(date_visionnage) INTO date_first
    from HISTORIQUE where id_user = :new.id_user;

    Select count(date_visionnage) INTO nb_video_vu_min_v
    from HISTORIQUE where id_user = :new.id_user
    AND ((extract(year from date_first) = extract(year from date_visionnage)) 
    AND  (extract(month from date_first) = extract(month from date_visionnage)) 
    AND  (extract(day from date_first) = extract(day from date_visionnage)) 
    AND  ((extract(hour from date_first) = extract(hour from date_visionnage)))
    AND  ((((extract(minute from date_first) - extract(minute from date_visionnage)) =1) 
        AND ((extract(second from date_first) < extract(second from date_visionnage)))) 
        OR  ((extract(minute from date_first) = extract(minute from date_visionnage)))));
    
    IF nb_video_vu_min_v > 2
        THEN 
        RAISE_APPLICATION_ERROR(-20002,'Pas de plus de 3 visionnage a la minute par utilisateur');
    END IF;
END;
/

