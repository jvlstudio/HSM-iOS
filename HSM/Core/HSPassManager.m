//
//  HSPassManager.m
//  HSM
//
//  Created by Felipe Ricieri on 27/06/14.
//  Copyright (c) 2014 ikomm Digital Solutions. All rights reserved.
//

#import "HSPassManager.h"

@implementation HSPassManager

- (void)recordValue:(NSString *)value forKey:(NSString *)key atIndexPath:(NSIndexPath *)ip withColor:(HSPassColor) color
{
    NSMutableArray *dplist          = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_MODEL];
    NSMutableDictionary *dpass      = [dplist objectAtIndex:color];
    NSMutableArray *sections        = [dpass objectForKey:@"sections"];
    NSMutableDictionary *secDict    = [sections objectAtIndex:ip.section];
    NSMutableArray *rows            = [secDict objectForKey:@"rows"];
    NSMutableDictionary *row        = [rows objectAtIndex:0];
    
    [row setObject:value forKey:key];
    
    [rows setObject:row atIndexedSubscript:0];
    [secDict setObject:rows forKey:@"rows"];
    [sections setObject:secDict atIndexedSubscript:ip.section];
    [dpass setObject:sections forKey:@"sections"];
    [dplist setObject:dpass atIndexedSubscript:color];
    
    [[HSMaster tools] propertyListWrite:dplist forFileName:HS_PLIST_PASSES_MODEL];
}
- (void)recordParticipant:(NSMutableDictionary *)dict atIndexPath:(NSIndexPath *)ip withColor:(HSPassColor) color
{
    NSMutableArray *dplist          = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_MODEL];
    NSMutableDictionary *dpass      = [dplist objectAtIndex:color];
    NSMutableArray *sections        = [dpass objectForKey:@"sections"];
    NSMutableDictionary *secDict    = [sections objectAtIndex:ip.section];
    NSMutableArray *rows            = [secDict objectForKey:@"rows"];
    
    NSInteger totalOfRows           = [rows count];
    NSInteger indexLastRow          = totalOfRows - 1;
    NSInteger limitOfRows           = [[secDict objectForKey:@"limit"] intValue];
    
    NSDictionary *addAnother        = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"4", @"type",
                                       @"add", @"subtype",
                                       @"Adicionar Participante", @"label", nil];
    NSMutableDictionary *row        = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"5", @"type",
                                       @"edit", @"subtype",
                                       @"yes", @"can_remove",
                                       [dict objectForKey:@"name"], @"label",
                                       dict, @"values", nil];
    
    // ...
    if (limitOfRows == 1)
        [row setObject:@"no" forKey:@"can_remove"];
    
    // add or edit?
    NSDictionary *tempDict = [self rowAtIndexPath:ip withColor:color];
    if ([[tempDict objectForKey:@"subtype"] isEqualToString:@"edit"])
    {
        [rows setObject:row atIndexedSubscript:ip.row];
    }
    else {
        [rows setObject:row atIndexedSubscript:indexLastRow];
        if(limitOfRows > [rows count])
            [rows addObject:addAnother];
    }
    
    [secDict setObject:rows forKey:@"rows"];
    [sections setObject:secDict atIndexedSubscript:ip.section];
    [dpass setObject:sections forKey:@"sections"];
    [dplist setObject:dpass atIndexedSubscript:color];
    
    [[HSMaster tools] propertyListWrite:dplist forFileName:HS_PLIST_PASSES_MODEL];
}
- (NSDictionary *) rowAtIndexPath:(NSIndexPath *)ip withColor:(HSPassColor) color
{
    NSMutableArray *dplist          = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_MODEL];
    NSMutableDictionary *dpass      = [dplist objectAtIndex:color];
    NSMutableArray *sections        = [dpass objectForKey:@"sections"];
    NSMutableDictionary *secDict    = [sections objectAtIndex:ip.section];
    NSMutableArray *rows            = [secDict objectForKey:@"rows"];
    NSDictionary *row               = [rows objectAtIndex:ip.row];
    
    return row;
}
- (BOOL) removeParticipantAtIndexPath:(NSIndexPath*) ip withColor:(HSPassColor) color
{
    NSDictionary *addAnother        = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"4", @"type",
                                       @"add", @"subtype",
                                       @"Adicionar Participante", @"label", nil];
    
    NSMutableArray *dplist          = [[HSMaster tools] propertyListRead:HS_PLIST_PASSES_MODEL];
    NSMutableDictionary *dpass      = [dplist objectAtIndex:color];
    NSMutableArray *sections        = [dpass objectForKey:@"sections"];
    NSMutableDictionary *secDict    = [sections objectAtIndex:ip.section];
    NSMutableArray *rows            = [secDict objectForKey:@"rows"];
    
    if ([rows count] == 5)
        [rows addObject:addAnother];
    [rows removeObjectAtIndex:ip.row];
    
    [secDict setObject:rows forKey:@"rows"];
    [sections setObject:secDict atIndexedSubscript:ip.section];
    [dpass setObject:sections forKey:@"sections"];
    [dplist setObject:dpass atIndexedSubscript:color];
    
    if([[HSMaster tools] propertyListWrite:dplist forFileName:HS_PLIST_PASSES_MODEL])
        return YES;
    else
        return NO;
}

@end
