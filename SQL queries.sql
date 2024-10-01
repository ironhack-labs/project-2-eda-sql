-- What is the most popular song of each year?
SELECT track, popularity, year
FROM tracks
INNER JOIN albums
	ON tracks.album_id = albums.album_id
WHERE popularity = (
	SELECT MAX(popularity)
    FROM tracks AS sub_tracks
    INNER JOIN albums AS sub_albums
		ON sub_tracks.album_id = sub_albums.album_id
	WHERE sub_albums.year = albums.year)
ORDER BY year
;

-- What's the most popular album? (Sum of the popularity of each album track divided by the number of tracks in the album)
SELECT albums.album, artist, (SUM(popularity) / COUNT(track_id)) album_popularity
FROM albums
INNER JOIN tracks
	ON albums.album_id = tracks.album_id
INNER JOIN artists
	ON albums.artist_id = artists.artist_id
GROUP BY albums.album, artist
ORDER BY album_popularity DESC
LIMIT 5
;

-- How many artists are in Rolling Stone Magazine's "100 Greatest Artists of All Time"?
SELECT COUNT(goat)
FROM artists
WHERE goat ="True"
;
SELECT artist
FROM artists
WHERE goat ="True"
;