# photo-album

Lean Techniques showcase

Hello!

This is Ruby script accomplishes the task for the LT Technical Showcases

## Setup

To run this solution ensure that you have Ruby installed on your machine

> ruby -v

If this doesn't return output similar to this `ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin19]` then you might not have Ruby installed on your system.

**NOTE** The default installed version of ruby on MacOS should be good. If you run into issues with ruby versioning you may need to install an older version.

Here is the offical Ruby-Lang download/install instructions https://www.ruby-lang.org/en/downloads/

Before executing the script you will need to give execution permissions to the file like so

```bash
chmod +x photo-album.rb
```

## Running

Once you have Ruby setup and installed you can run the script like so from your terminal:

```bash
./photo-album.rb <ALBUM ID ARGUMENT>
```

Where `<ALBUM ID ARGUMENT>` is an integer for an album id you wish to return

### Additional Filtering

Additionally you can add additional filtering of the photos within an album by any of the attributes that make up a photo.

To add the extra filtering you can pass in the attribute name and value you're looking for

```bash
./photo-album.rb <ALBUM ID ARGUMENT> <FILTER BY ARGUEMENT> <VALUE SEARCHING FOR>
```

To search the first album for the thumbnailUrl of https://via.placeholder.com/150/9e59da you would pass in

```bash
./photo-album.rb 1 thumbnailUrl https://via.placeholder.com/150/9e59da
```

Here would be the output from that filter

`[50] et inventore quae ut tempore eius voluptatum`

### NOTES

- Running the script to retrieve photos from a specific album will also run the tests.
- Giving no album id input will return all 5000 photos
- Giving an invalid album id with zero results returns a simple error message
- Providing no filter args will output a simple informative message