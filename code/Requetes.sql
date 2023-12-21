-------------------------------------------------Requetes du projet ----------------
--1) 
Select distinct(categorie_emission.categorie) as "categorie", 
count(historique.id_video) as "nb_visio_par_categorie"
from categorie_emission 
LEFT JOIN historique on historique.id_video in 
(Select id_video from video where id_emi in 
(Select id_emi from emission where id_emi = categorie_emission.id_emi)) 
and ((trunc(localtimestamp,'DDD') - trunc(date_visionnage,'DDD'))   < 14)
group by categorie_emission.categorie;

-- 2)-
Select distinct utilisateur.id_user , count(distinct favoris.id_video) 
as "nb_favoris" ,count(distinct historique.id_video) 
as "nb_visio" , count(distinct abonnement.id_emi)
as "nb_abonnement"
FROM utilisateur 
LEFT JOIN favoris on utilisateur.id_user = favoris.id_user
LEFT JOIN historique on utilisateur.id_user = historique.id_user 
LEFT JOIN abonnement on utilisateur.id_user = abonnement.id_user
group by utilisateur.id_user;

--3)
Select distinct(id_video),count(U1.id_user) 
as "nb_visio francais",count(U2.id_user) 
as "nb visio allemand" ,
CASE
    when count(U1.id_user) > count(U2.id_user) then count(U1.id_user) - count(U2.id_user)
    when count(U1.id_user) <= count(U2.id_user) then count(U2.id_user) - count(U1.id_user)
END as "difference" 
FROM historique 
LEFT JOIN utilisateur U1 on historique.id_user = U1.id_user and U1.langue = 'francais'
LEFT JOIN utilisateur U2 on historique.id_user = U2.id_user and U2.langue = 'allemand'
GROUP by id_video
having ABS((count(U1.id_user))-count(U2.id_user)) >= 0;

-- 4)
Select V1.id_video from video V1,video V2 
where (V1.id_emi = V2.id_emi and V1.id_video <> V2.id_video) 
and V1.id_video in (Select id_video from historique where V1.id_video <> V2.id_video group by id_video having count(V1.id_video)>count(V2.id_video));

--5)
Select V1.id_video,V2.id_video 
from video V1, video V2 
where V1.id_video <> V2.id_video;


