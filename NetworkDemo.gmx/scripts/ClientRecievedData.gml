/// Read incoming data to the server from a connected saocket
{  
    // get the buffer the data resides in
    var buff = ds_map_find_value(async_load, "buffer");
    // read ythe command 
    buffer_save(buff, "Client recieve debuff buffer.txt");
    //textfile = file_text_open_append("Client Network Log.txt");
    // Get the socket ID - this is the CLIENT socket ID. We can use this as a "key" for this client
    //var sock = ds_map_find_value(async_load, "id");
    // Look up the client details
    var cmd = buffer_read(buff, buffer_s16 );
    /*file_text_write_string(textfile,"Client Recieve Data Begin: " + string(current_time))
    file_text_writeln(textfile)
    file_text_write_string(textfile,"CMD: "+string(cmd))
    file_text_writeln(textfile)*/
    // Is this a KEY command?
    if( cmd==KEY_CMD )    
    {
        var truisnt = buffer_read(buff, buffer_s32 );
        var pos = ds_list_find_index(global.ServerInstances,truisnt);
        var inst = ds_list_find_value(global.ClientInstances,pos);
        // Read the key that was sent
        var key = buffer_read(buff, buffer_u16 );
        // And it's up/down state
        var updown = buffer_read(buff, buffer_u16 );
        inst.x = buffer_read(buff, buffer_s16);
        inst.y = buffer_read(buff, buffer_s16);
        /*file_text_write_string(textfile,"KEY COMMAND Begin")
        file_text_writeln(textfile)
        file_text_write_string(textfile,"Instance: "+string(truisnt))
        file_text_writeln(textfile)
        file_text_write_string(textfile,"Key: "+string(key))
        file_text_writeln(textfile)
        file_text_write_string(textfile,"Updown: "+string(updown))
        file_text_writeln(textfile)
        file_text_write_string(textfile,"KEY COMMAND End")
        file_text_writeln(textfile)*/
         
        // translate updown into a bool for the player array       
        //if( updown==0 ){
                        if updown !=0 and updown!=1
        {
        inst.name=string(updown)
        }else//*/
            inst.keys[key] = updown;
    }else if( cmd==CHAT_CMD )
    {
        ds_list_add(global.chat,buffer_read(buff, buffer_string));
        //file_text_write_string(textfile,"Chat message recieved: " + string(ds_list_read(global.chat,ds_list_size(global.chat)-1)))
        //file_text_writeln(textfile)
    }
    // Is this a NAME command?
    else if( cmd==NAME_CMD )    
    {
        // Set the client "name"
        //inst.PlayerName = buffer_read(buff, buffer_string );    
    }
    else if( cmd==PING_CMD )
    {
        // keep alive - ignore it
    }
    else if (cmd == PLAYERDC_CMD )
    {
        //file_text_write_string(textfile,"DESTROY ITEM COMMAND")
        //file_text_writeln(textfile)
        var sInst = buffer_read(buff, buffer_s32);
        var delPos = ds_list_find_index(global.ServerInstances, sInst) 
        var delInst = ds_list_find_value(global.ClientInstances,delPos)
        with(delInst)
            instance_destroy()
        ds_list_delete(global.ServerInstances,delPos)
        ds_list_delete(global.ClientInstances,delPos)
        /*file_text_write_string(textfile,"Server instance marked for deletion: " + string(sInst) )
        file_text_writeln(textfile)
        file_text_write_string(textfile,"Client instance deleted: " + string(delInst) )
        file_text_writeln(textfile)
        file_text_write_string(textfile,"End DESTROY ITEM COMMAND" )
        file_text_writeln(textfile)*/
    }
    else if (cmd == ADD_BULLET)
    {
        //file_text_write_string(textfile,"CREATE BULLET COMMAND" )
        //file_text_writeln(textfile)
        /*buffer_write(mBuffer, buffer_s32, instProj.id );
        buffer_write(mBuffer, buffer_s16, instProj.x );
        buffer_write(mBuffer, buffer_s16, instProj.y );
        buffer_write(mBuffer, buffer_s16, instProj.direction );
        buffer_write(mBuffer, buffer_s16, instProj.speed );*/
        var truisnt = buffer_read(buff, buffer_s32 );
        ds_list_add(global.ServerInstances,truisnt);
        var tx = buffer_read(buff, buffer_s16);
        var ty = buffer_read(buff, buffer_s16);
        var bulletID = instance_create(tx, ty, oClientProjectile)
        ds_list_add(global.ClientInstances,bulletID);
        bulletID.direction = buffer_read(buff, buffer_s16 );
        bulletID.image_angle = bulletID.direction;
        bulletID.speed = buffer_read(buff, buffer_s16 );
        /*file_text_write_string(textfile,"Server instance: " + string(truisnt) )
        file_text_writeln(textfile)
        file_text_write_string(textfile,"Client instance create: " + string(bulletID) )
        file_text_writeln(textfile)
        file_text_write_string(textfile,"X: " + string(tx) )
        file_text_writeln(textfile)
        file_text_write_string(textfile,"Bullet direction: " + string(bulletID.direction) )
        file_text_writeln(textfile)
        file_text_write_string(textfile,"Bullet speed: " + string(bulletID.speed) )
        file_text_writeln(textfile)*/
    }
    else if( cmd == 9 )
    {
            // Get number of sprites sent
            sprites =  buffer_read(buff, buffer_u32 ); 
            
            // Read out OUR location (allow scrolling maps)
            clientx = buffer_read(buff,buffer_s16);     //x
            clienty = buffer_read(buff,buffer_s16);     //y
        
            // Now clear the render list, and start filling it up with NEW data!
            ds_list_clear(allsprites);
            for(var i=0;i<sprites;i++){
                ds_list_add(allsprites, buffer_read(buff,buffer_s16) );     //x
                ds_list_add(allsprites, buffer_read(buff,buffer_s16) );     //y
                ds_list_add(allsprites, buffer_read(buff,buffer_s16) );     //sprite_index
                ds_list_add(allsprites, buffer_read(buff,buffer_s16) );     //image_index
                ds_list_add(allsprites, buffer_read(buff,buffer_s32) );     //image_blend        
                ds_list_add(allsprites, buffer_read(buff,buffer_string) );  // player name
            }
    }
    else if (cmd == GUN_ANGLE_CMD)
    {
        //file_text_write_string(textfile,"GUN REANGLE COMMAND" )
        //file_text_writeln(textfile)
        var truisnt = buffer_read(buff, buffer_s32 );
        var pos = ds_list_find_index(global.ServerInstances,truisnt);
        var inst = ds_list_find_value(global.ClientInstances,pos);
        var newAngle = buffer_read(buff, buffer_s16);
        inst.aimAngle = newAngle
        /*file_text_write_string(textfile,"Server instance: " + string(truisnt) )
        file_text_writeln(textfile)
        file_text_write_string(textfile,"Client instance: " + string(inst) )
        file_text_writeln(textfile)
        file_text_write_string(textfile,"New angle: " + string(newAngle) )
        file_text_writeln(textfile)*/
    }
    else if (cmd == SYNC_CMD)
    {
            //file_text_write_string(textfile,"SYNC COMMAND" )
            //file_text_writeln(textfile)
            // Get number of sprites sent
            sprites =  buffer_read(buff, buffer_u32 ); 
            //file_text_write_string(textfile,"Number of items to sync: " + string(sprites) )
            //file_text_writeln(textfile)
            // Now clear the render list, and start filling it up with NEW data!
            for(var i=0;i<sprites;i++)
            {
                //file_text_write_string(textfile,"Item: " + string(i+1) )
                //file_text_writeln(textfile)
                var o = buffer_read(buff,buffer_s16)
                var ox = buffer_read(buff,buffer_s16)     //x
                var oy = buffer_read(buff,buffer_s16)     //y
                var synco = instance_create(ox,oy,o);
                synco.sprite_index = buffer_read(buff,buffer_s16)    //sprite_index
                synco.image_index = buffer_read(buff,buffer_s16);     //image_index
                synco.image_blend = buffer_read(buff,buffer_s32)     //image_blend        
                synco.name = buffer_read(buff,buffer_string)         //player name
                var serverInst = buffer_read(buff, buffer_s32)
                ds_list_add(global.ServerInstances,serverInst)
                ds_list_add(global.ClientInstances,synco)
                synco.client=true
                if synco.image_index=2
                {
                        synco.gun=sniper
                        synco.laser_sight=true
                }
                else if synco.image_index=3
                        synco.gun=bulletthrower
                else if synco.image_index>3
                        synco.gun=shotgun
                /*file_text_write_string(textfile,"Object type: " + string(o) )
                file_text_writeln(textfile)
                file_text_write_string(textfile,"X: " + string(ox) )
                file_text_writeln(textfile)
                file_text_write_string(textfile,"Y: " + string(oy) )
                file_text_writeln(textfile)
                file_text_write_string(textfile,"Sprite index: " + string(synco.sprite_index) )
                file_text_writeln(textfile)
                file_text_write_string(textfile,"Image index: " + string(synco.image_index) )
                file_text_writeln(textfile)
                file_text_write_string(textfile,"Color: " + string(synco.image_blend) )
                file_text_writeln(textfile)
                file_text_write_string(textfile,"Name: " + string(synco.name) )
                file_text_writeln(textfile)
                file_text_write_string(textfile,"Server instance: " + string(serverInst) )
                file_text_writeln(textfile)*/
            }
            //file_text_write_string(textfile,"SYNC COMMAND End" )
            //file_text_writeln(textfile)
    }
    /*file_text_write_string(textfile,"Client Recieve Data End")
    file_text_writeln(textfile)
    file_text_writeln(textfile)
    file_text_close(textfile)*/
    buffer_delete(buff)
}

