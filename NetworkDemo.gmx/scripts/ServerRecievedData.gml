/// Read incoming data to the server from a connected saocket
{  textfile = file_text_open_append("networking log.txt");
    file_text_write_string(textfile,"Server Recieve Data Begin")
    file_text_writeln(textfile)
    // get the buffer the data resides in
    var buff = ds_map_find_value(async_load, "buffer");
    buffer_save(buff, "Server recieve debuff buffer.txt");
    // read ythe command 
    var cmd = buffer_read(buff, buffer_s16 );
    file_text_write_string(textfile,string(cmd))
    file_text_writeln(textfile)
    // Get the socket ID - this is the CLIENT socket ID. We can use this as a "key" for this client
    var sock = ds_map_find_value(async_load, "id");
    // Look up the client details
    var inst = ds_map_find_value(Clients, sock );

    // Is this a KEY command?
    if( cmd==KEY_CMD )    
    {
        // Read the key that was sent
        var key = buffer_read(buff, buffer_s16 );
        file_text_write_string(textfile,string(key))
        file_text_writeln(textfile)
        // And it's up/down state
        var updown = buffer_read(buff, buffer_s16 );
        file_text_write_string(textfile,string(updown))
        file_text_writeln(textfile)
        // translate keypress into an index for our player array.
         
        // translate updown into a bool for the player array       
        //if( updown==0 ){
                if updown !=0 and updown!=1
        {
            testupdown=updown
        }else
            inst.keys[key] = updown;
        /*}else{
            inst.keys[key] = true;
        }*/
        file_text_write_string(textfile,"Server Recieve Data End")
        file_text_writeln(textfile)
        file_text_write_string(textfile,"Server Send Button Press Data Begin")
        file_text_writeln(textfile)
        buffzz = buffer_create(1, buffer_grow, 1);
        buffer_seek(buffzz, buffer_seek_start, 0);
        buffer_write(buffzz, buffer_s16, KEY_CMD );
        buffer_write(buffzz, buffer_s32, inst.id );
        buffer_write(buffzz, buffer_u16, key );
        buffer_write(buffzz, buffer_u16, updown );
        buffer_write(buffzz, buffer_s16, inst.x );
        buffer_write(buffzz, buffer_s16, inst.y );
        buffer_save(buffzz, "Server send keypress buffer.txt");
        file_text_write_string(textfile,string(KEY_CMD))
        file_text_writeln(textfile)
        file_text_write_string(textfile,string(inst.id))
        file_text_writeln(textfile)
        file_text_write_string(textfile,string(key))
        file_text_writeln(textfile)
        file_text_write_string(textfile,string(updown))
        file_text_writeln(textfile)
        file_text_write_string(textfile,"Server Send Button Press Data End")
        file_text_writeln(textfile)
        var b2 = buffer_load("Server send keypress buffer.txt");
        file_text_write_string(textfile,"Read sent buffer from file")
        file_text_writeln(textfile)
        file_text_write_string(textfile,string(buffer_read(b2, buffer_s16)));
        file_text_writeln(textfile)
        file_text_write_string(textfile,string(buffer_read(b2, buffer_s32)));
        file_text_writeln(textfile)
        file_text_write_string(textfile,string(buffer_read(b2, buffer_u16)));
        file_text_writeln(textfile)
        file_text_write_string(textfile,string(buffer_read(b2, buffer_u16)));
        file_text_writeln(textfile)
        var count = ds_list_size(socketlist);
        if( count>0 )
        {
            for(i=0;i<count;i++)
            { 
                network_send_packet( ds_list_find_value(socketlist,i), buffzz, buffer_get_size(buffzz));
            }
            buffer_delete(buffzz)
        }
    }
    // Is this a NAME command?
    else if( cmd==NAME_CMD )    
    {
        // Set the client "name"
        inst.PlayerName = buffer_read(buff, buffer_string );
        inst.image_index = buffer_read(buff, buffer_s16 );    
                  /// Send all sprites to all clients
    global.player_buffer = player_buffer;
    
    // Reset buffer to start - Networking ALWAYS reads from the START of the buffer
    buffer_seek(player_buffer, buffer_seek_start, 0);
    buffer_write(player_buffer, buffer_s16, SYNC_CMD);
    // Total number of sprites (players+baddies)
    buffer_write(player_buffer, buffer_u32, global.PlayerTotal+global.BaddieCount );

    // All attached players
    with(oPlayer)
    {
        if client=false{
        buffer_write(global.player_buffer, buffer_s16, object_index );
        buffer_write(global.player_buffer, buffer_s16, x );
        buffer_write(global.player_buffer, buffer_s16, y );
        buffer_write(global.player_buffer, buffer_s16, sprite_index );
        buffer_write(global.player_buffer, buffer_s16, image_index );
        buffer_write(global.player_buffer, buffer_s32, image_blend );
        buffer_write(global.player_buffer, buffer_string, PlayerName );
        buffer_write(global.player_buffer, buffer_s32, id );
        }
    }
    
    // Now send all baddies
    with(oBaddie)
    {
        buffer_write(global.player_buffer, buffer_s16, object_index );
        buffer_write(global.player_buffer, buffer_s16, x );
        buffer_write(global.player_buffer, buffer_s16, y );
        buffer_write(global.player_buffer, buffer_s16, sprite_index );
        buffer_write(global.player_buffer, buffer_s16, image_index );
        buffer_write(global.player_buffer, buffer_s32, image_blend );
        buffer_write(global.player_buffer, buffer_string, "Da Big Booty");
        buffer_write(global.player_buffer, buffer_s32, id );
    }
    var buffer_size = buffer_tell(player_buffer);
    // get the socket
    network_send_packet( sock,player_buffer, buffer_size );
    // Now send all data... to all clients 
    with(inst)
        {
            if image_index=1
                InitRocket()
            else if image_index=2
                InitSniper()
            else if image_index=3
                InitBulletThrower()
            else if image_index>3
                InitShoto()
            else
                InitGatgat()
            global.pBuffer = buffer_create(1, buffer_grow, 1)
            buffer_write(global.pBuffer, buffer_s16, SYNC_CMD);
            buffer_write(global.pBuffer, buffer_u32, 1);
            buffer_write(global.pBuffer, buffer_s16, object_index );
            buffer_write(global.pBuffer, buffer_s16, x );
            buffer_write(global.pBuffer, buffer_s16, y );
            buffer_write(global.pBuffer, buffer_s16, sprite_index );
            buffer_write(global.pBuffer, buffer_s16, image_index );
            buffer_write(global.pBuffer, buffer_s32, image_blend );
            buffer_write(global.pBuffer, buffer_string, PlayerName );
            buffer_write(global.pBuffer, buffer_s32, id );
        }
            var count = ds_list_size(socketlist)-1;
            if( count>0 )
            {
                for(i=0;i<count;i++)
                {
                    if ds_list_find_value(socketlist,i)!=sock
                    network_send_packet( ds_list_find_value(socketlist,i), global.pBuffer, buffer_get_size(global.pBuffer));
                }
            }
            buffer_delete(global.pBuffer)
    }
    else if( cmd==GUN_ANGLE_CMD )
    {
        var nx = buffer_read(buff, buffer_s16);
        var ny = buffer_read(buff, buffer_s16);
        inst.aimX=nx
        inst.aimY=ny
        if inst.image_xscale=-1
        inst.aimAngle=point_direction(nx,ny,inst.x,inst.y+23);
        else
        inst.aimAngle=point_direction(inst.x,inst.y+23,nx,ny);
        var mBuffer = buffer_create(1, buffer_grow, 1)
        buffer_write(mBuffer, buffer_s16, GUN_ANGLE_CMD );
        buffer_write(mBuffer, buffer_s32, inst.id );
        buffer_write(mBuffer, buffer_s16, inst.aimAngle );
        var count = ds_list_size(socketlist);
        if( count>0 )
        {
            for(i=0;i<count;i++)
            { 
                network_send_packet( ds_list_find_value(socketlist,i),mBuffer, buffer_get_size(mBuffer));
            }
        }
        buffer_delete(mBuffer)
    }
    else if( cmd==PING_CMD )
    {
        // keep alive - ignore it
    }
    else if( cmd == CHAT_CMD)
    {   
        var count = ds_list_size(socketlist);
        var chatmsg = buffer_read(buff,buffer_string)
        buffer_seek(buff, buffer_seek_start, 0);
        buffer_write(buff, buffer_s16, CHAT_CMD );
        buffer_write(buff, buffer_string, chatmsg);
        var buffsize =buffer_tell(buff);
        if( count>0 )
        {
            for(i=0;i<count;i++)
            { 
                network_send_packet( ds_list_find_value(socketlist,i), buff, buffsize );
            }
        }
    }//*/
    file_text_close(textfile)
}


