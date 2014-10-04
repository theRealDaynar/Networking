/// Read incoming data to the server from a connected saocket
{  
    // get the buffer the data resides in
    var buff = ds_map_find_value(async_load, "buffer");
    // read ythe command 
    //buffer_save(buff, "Client recieve debuff buffer.txt");
    //textfile = file_text_open_append("Client Network Log.txt");
    // Get the socket ID - this is the CLIENT socket ID. We can use this as a "key" for this client
    //var sock = ds_map_find_value(async_load, "id");
    // Look up the client details
    var cmd = buffer_read(buff, buffer_s16 );
    /*file_text_write_string(textfile,"Client Recieve Data Begin: " + string(current_time))
    file_text_writeln(textfile)
    file_text_write_string(textfile,"CMD: "+string(cmd))
    file_text_writeln(textfile)*/
    if cmd = -1
    {
    
        //read shotgun approch
        //if update is more recent than last update
        var TlastUpdate = buffer_read(buff, buffer_u32)
        if lastUpdate < TlastUpdate
        {
            lastUpdate = TlastUpdate
            //send acknoledgement to server
            var pingS = buffer_create(1, buffer_grow, 1)
            var newServertime = buffer_read(buff, buffer_u32)
            var newClienttime = current_time
            var cTimeDiff = newClienttime-clienttime
            var sTimeDiff = newServertime-servertime
            var timeInThePast = newClienttime - (cTimeDiff-sTimeDiff)
            buffer_write(pingS, buffer_s16, -1)
            buffer_write(pingS, buffer_u32, lastUpdate)
            buffer_write(pingS, buffer_u32, servertime)
            network_send_packet( client, pingS, buffer_get_size(pingS) );
            buffer_delete(pingS)
            //update information on player characters
            var uPlayerNum = buffer_read(buff, buffer_u8)
            for(var i = 0; i<uPlayerNum;i++)
            {
                var truisnt = buffer_read(buff, buffer_u32)
                var inst = ds_list_find_value(global.ClientInstances,ds_list_find_index(global.ServerInstances,truisnt));
                var newdeaths = buffer_read(buff, buffer_u8)
                if inst!=0
                {
                    var olddeaths = inst.deaths ;
                    inst.deaths=newdeaths
                    if newdeaths>olddeaths
                                    {
                (instance_create(room_width/2,room_height/2,oCongratsText)).text1=inst.PlayerName+" has been slain!"
                with(inst)
                    for(var ii; i<5;i++)
                        instance_create(bbox_left+random(bbox_right-bbox_left),bbox_top+random(bbox_bottom-bbox_top),oPuff)
                }
                }
                else
                {
                var olddeaths=newdeaths-1;
                inst=id
                }
                inst.x = buffer_read(buff, buffer_s16)
                inst.y = buffer_read(buff, buffer_s16)
                if olddeaths=newdeaths
                {
                    with(inst)
                    {
                        var neededCorrection = distance_to_point(xprevious, yprevious)
                        if neededCorrection > 2 and neededCorrection < 500
                        {
                            mx = xprevious - x
                            my = yprevious - y
                            if neededCorrection < 5
                                ms = 1
                            else if neededCorrection < 15
                                ms = 3
                            else
                                ms = neededCorrection/10
                            
                        }
                    }
                }

                for(var ii = 0;ii < 4;ii++)
                {
                        inst.keys[ii] = buffer_read(buff, buffer_bool)
                }
                inst.ghost=buffer_read(buff, buffer_bool)
                inst.aimX = buffer_read(buff, buffer_s16)
                inst.aimY = buffer_read(buff, buffer_s16)
                if inst!=ClientPlayer
                    with(inst)
                    {
                        if image_xscale=-1
                            aimAngle=point_direction(aimX,aimY,x,y+23);
                        else
                            aimAngle=point_direction(x,y+23,aimX,aimY);
                    }
                inst.grav = buffer_read(buff, buffer_s8)
                inst.recoilSpeed = buffer_read(buff, buffer_s8)
                inst.recoilDirection = buffer_read(buff, buffer_s16)
                var lostSteps = floor((current_time-timeInThePast)/(1000/room_speed));
                if servertime=0
                {
                    if inst.image_speed=1
                        event_perform_object(inst,ev_create,ev_create)
                    for(ii = 0;ii<lostSteps;ii++)
                        event_perform_object(inst,ev_step,ev_step_normal)
                }
            }
            var uBulletNum = buffer_read(buff, buffer_u8)
            if uBulletNum = 0
            {
                with(oClientProjectile)
                    instance_destroy()
                audio_sound_gain(bgm2i,0,0)
                audio_sound_gain(bgm3i,0,0)
            }
            else
            {
                if uBulletNum<50
                {
                    audio_sound_gain(bgm2i,uBulletNum/50,0)
                    audio_sound_gain(bgm3i,0,0)
                }
                else
                {
                    audio_sound_gain(bgm2i,1,0)
                    audio_sound_gain(bgm3i,(uBulletNum-50)/50,0)
                }
            }
            for(i = 0; i<uBulletNum;i++)
            {
                inst = instance_find(oClientProjectile, i)
                if inst < 0
                    inst = instance_create(0,0,oClientProjectile)
                inst.x = buffer_read(buff, buffer_s16)
                inst.y = buffer_read(buff, buffer_s16)
                inst.direction = buffer_read(buff, buffer_s16);
                var lostSteps = floor((current_time-timeInThePast)/(1000/room_speed));
                if servertime!=0
                repeat(lostSteps)
                {
                    inst.x+=hspeed
                    inst.y+=vspeed
                }
            }
            while(instance_find(oClientProjectile,i-1)>0)
            {
                with(instance_find(oClientProjectile,i++))
                    instance_destroy()
            }
            servertime=newServertime
            clienttime=newClienttime
        }
    
    // Is this a KEY command?
    }else if( cmd==KEY_CMD )    
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
        if key = MB_LEFT
            random_set_seed(buffer_read(buff, buffer_s32))
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
    else if( cmd == 11 )
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
    else if (cmd == FIRST_SYNC_CMD)
    {
        sprites =  buffer_read(buff, buffer_u32 );
        var cp = buffer_read(buff, buffer_u32)
        for(var i=0;i<sprites;i++)
        {
                var o = buffer_read(buff,buffer_s16)
                var ox = buffer_read(buff,buffer_s16)     //x
                var oy = buffer_read(buff,buffer_s16)     //y
                var synco = instance_create(ox,oy,o);
                synco.sprite_index = buffer_read(buff,buffer_s16)    //sprite_index
                synco.image_index = buffer_read(buff,buffer_s16);     //image_index
                synco.image_blend = buffer_read(buff,buffer_s32)     //image_blend        
                synco.PlayerName = buffer_read(buff,buffer_string)         //player name
                var serverInst = buffer_read(buff, buffer_s32)
                if serverInst = cp
                ClientPlayer = synco
                ds_list_add(global.ServerInstances,serverInst)
                ds_list_add(global.ClientInstances,synco)
                with(synco)
                {
                    client=true
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
                }
            }
    }
    else if (cmd == GUN_ANGLE_CMD)
    {
        //file_text_write_string(textfile,"GUN REANGLE COMMAND" )
        //file_text_writeln(textfile)
        var truisnt = buffer_read(buff, buffer_s32 );
        var pos = ds_list_find_index(global.ServerInstances,truisnt);
        var inst = ds_list_find_value(global.ClientInstances,pos);
        if inst!=ClientPlayer
        {
            var newAngle = buffer_read(buff, buffer_s16);
            inst.aimAngle = newAngle
        }
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
                synco.PlayerName = buffer_read(buff,buffer_string)         //player name
                var serverInst = buffer_read(buff, buffer_s32)
                ds_list_add(global.ServerInstances,serverInst)
                ds_list_add(global.ClientInstances,synco)
                with(synco)
                {
                    client=true
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
                }
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
    }else if cmd=13
    {
        instance_create(room_width/2,room_height/3,oCountDownLabel)
        playing=true
    }
    /*file_text_write_string(textfile,"Client Recieve Data End")
    file_text_writeln(textfile)
    file_text_writeln(textfile)
    file_text_close(textfile)*/
    buffer_delete(buff)
}

