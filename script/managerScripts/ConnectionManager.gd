extends Node

signal new_map_position(scene_name: String)
signal user_seed(scene_name:String)
signal time_of_day(scene_name:String)            
signal item_in_range(scene_name:String)         
signal right_click_split(scene_name:String) 
signal left_click_drag(scene_name:String)     
signal daytime_change(scene_name:String)
 
signal health_change(scene_name:String)
signal hunger_change(scene_name:String)    
signal player_collect(scene_name:String)    
 
signal change_to_sprites(scene_name:String)    
signal chopped_tree(scene_name:String)                                 
signal broken_object_drops(scene_name:String)
signal direct_item_drops(scene_name:String)  

signal day_change(scene_name:String)    
signal new_chunk_entered(scene_name:String)                                                                                                                                                        

signal change_season(scene_name:String)

signal update_equipment_slots

signal camera_changer(scene_name:String)

signal shoot_bow(scene_name:String)

signal right_equipment(scene_name:String)
signal left_equipment(scene_name:String)

signal scroll_up(scene_name:String)
signal scroll_down(scene_name:String)

signal recipe_clicked(scene_name:String) 
