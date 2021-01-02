# photo-album
Lean Techniques showcase

Hello!

This is a Ruby script accomplishes the task for Option 1 for the LT Technical Showcases

To run this solution ensure that you have Ruby installed on your machine

> ruby -v

If this doesn't return output similar to this `ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin19]` then you might not have Ruby installed on your system.

Here is the offical Ruby-Lang download/install instructions https://www.ruby-lang.org/en/downloads/

Once you have Ruby setup and installed you can run the script like so from your terminal:

```bash
./photo-album.rb <ALBUM ID ARGUMENT>
```

Where `<ALBUM ID ARGUMENT>` is an integer for an album id

### NOTES

- Running the script to retrieve photos from a specific album will also run the tests.
- Giving no album id input will return all 5000 photos
- Giving an invalid album id with zero results returns a simple error message