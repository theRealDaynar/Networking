/// Called on a connect or disconnect of a client
{
    // get connect or disconnect (1=connect)
    var t = ds_map_find_value(async_load, "type");

    // Get the NEW socket ID, or the socket that's disconnecting
    var sock = ds_map_find_value(async_load, "socket");
    
    // Get the IP that the socket comes from
    var ip = ds_map_find_value(async_load, "ip");
    var port = ds_map_find_value(async_load, "port");
    
    // Connecting?
    if( t==network_type_connect)
    {
        global.PlayerTotal++;
        // add client to our list of connected clients
        ds_list_add( socketlist, sock );
        ds_list_add( iplist, ip);
        ds_list_add( portlist, port);
        // Create a new player, and pick a random colour for that player        
        var inst = instance_create(64,192, oPlayer);
        //randomize()
        //inst.image_index = floor(random(sprite_get_number(sCharacters)))
        inst.image_blend = ColourArray[colourindex];
        colourindex = (colourindex+1) & 15;

        // put this instance into a map, using the socket ID as the lookup
        ds_map_add( Clients, sock, inst );
        
        //send new player infor to clients
        
    }
    else
    {
        global.PlayerTotal--;
        // disconnect a CLIENT. First find the player instance using the socket ID as a lookup
        var inst = ds_map_find_value(Clients, sock );
        // Create a disconnecting "PUFF" at the current coords
        instance_create( inst.x, inst.y, oPuff );

                // Delete the socket from out map, and kill the player instance
        ds_map_delete(Clients, sock );
        with(inst) { instance_destroy(); }
        
        // Also delete the socket from our global list of connected clients
        var index = ds_list_find_index( socketlist, sock );
        ds_list_delete(socketlist,index);
        global.pBuffer = buffer_create(1, buffer_grow, 1)
        buffer_write(global.pBuffer, buffer_s16, PLAYERDC_CMD);
        buffer_write(global.pBuffer, buffer_s32, inst)
        var count = ds_list_size(socketlist);
            if( count>0 )
            {
                for(i=0;i<count;i++)
                {
                    network_send_packet( ds_list_find_value(socketlist,i), global.pBuffer, buffer_get_size(global.pBuffer));
                }
            }
            buffer_delete(global.pBuffer)
    }
}


